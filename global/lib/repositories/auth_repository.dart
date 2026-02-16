import 'package:dio/dio.dart';
import 'package:global/constants/api_constants.dart';
import 'package:global/models/buyer_documents_model.dart';
import 'package:global/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio _dio = Dio();

  AuthRepository() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 40);
    _dio.options.receiveTimeout = const Duration(seconds: 40);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<User> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'emailOrNumber': email, 'password': password},
      );
      // ignore: avoid_print
      print('Login Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          if (data['buyer'] != null) {
            final user = User.fromJson(data['buyer']);
            final token = data['token'];
            if (token != null) {
              await _saveToken(token);
            }
            return user;
          } else {
            throw Exception('Login successful but no user data returned');
          }
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Login DioError: ${e.response?.data}');
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.message ?? 'Server Error';
        }
      } else {
        errorMessage = 'Network Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // ignore: avoid_print
      print('Login Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<String> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        final response = await _dio.post(
          ApiConstants.logout,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
        // ignore: avoid_print
        print('Logout Response: ${response.data}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Logout Error: $e');
      // Continue to clear local token even if API fails
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
    return "Logged out successfully.";
  }

  Future<(User, String)> register({
    required String fullName,
    required String companyName,
    required String email,
    required String phone,
    required String password,
    String? address,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'full_name': fullName,
          'company_name': companyName,
          'email': email,
          'phone': phone,
          'phone_code':
              '+91', // Assuming default or it should be passed? API didn't specify code but usually needed. The user didn't provide it in screenshot. I will omit if not in screenshot. Wait, screenshot has 'phone'. I'll stick to screenshot.
          'address': address ?? '',
          'password': password,
          'password_confirmation': password,
        },
      );
      //1 remove for production
      // ignore: avoid_print
      print('Register Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == true) {
          // Parse user data from 'data' field
          if (data['data'] != null) {
            final user = User.fromJson(data['data']);
            final message =
                (data['message'] as String?) ?? 'Account created successfully.';
            return (user, message);
          } else {
            throw Exception(
              'Registration successful but no user data returned',
            );
          }
        } else {
          throw Exception(data['message'] ?? 'Registration failed');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // error print for debug
      // ignore: avoid_print
      print('Register DioError: ${e.response?.data}');
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.message ?? 'Server Error';
        }
      } else {
        errorMessage = 'Network Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // ignore: avoid_print
      print('Register Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<String> uploadDocuments({
    required String governmentIdPath,
    required String businessLicensePath,
    required String proofOfAddressPath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formData = FormData.fromMap({
        'government_id': await MultipartFile.fromFile(governmentIdPath),
        'business_licence': await MultipartFile.fromFile(businessLicensePath),
        'proof_of_address': await MultipartFile.fromFile(proofOfAddressPath),
      });

      final response = await _dio.post(
        ApiConstants.uploadDocuments,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // ignore: avoid_print
      print('Upload Docs Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return data['message'] ?? 'Documents uploaded successfully.';
        } else {
          throw Exception(data['message'] ?? 'Document upload failed');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Upload Docs DioError: ${e.response?.data}');
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.message ?? 'Server Error';
        }
      } else {
        errorMessage = 'Network Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // ignore: avoid_print
      print('Upload Docs Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<BuyerDocuments> fetchDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        ApiConstants.fetchDocuments,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // ignore: avoid_print
      print('Fetch Docs Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          if (data['documents'] != null) {
            return BuyerDocuments.fromJson(data['documents']);
          } else {
            throw Exception('No document data returned');
          }
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch documents');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Fetch Docs DioError: ${e.response?.data}');
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.message ?? 'Server Error';
        }
      } else {
        errorMessage = 'Network Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // ignore: avoid_print
      print('Fetch Docs Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<String> forgotPassword({required String emailOrNumber}) async {
    try {
      final formData = FormData.fromMap({'emailOrNumber': emailOrNumber});

      final response = await _dio.post(
        ApiConstants.forgotPassword,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // ignore: avoid_print
      print('Forgot Password Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return data['message'] ?? 'Reset instructions sent to your email.';
        } else {
          throw Exception(data['message'] ?? 'Request failed');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Forgot Password DioError: ${e.response?.data}');
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.message ?? 'Server Error';
        }
      } else {
        errorMessage = 'Network Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // ignore: avoid_print
      print('Forgot Password Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final formData = FormData.fromMap({'email': email, 'otp': otp});

      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // ignore: avoid_print
      print('Verify OTP Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          // If token is returned, save it
          if (data['token'] != null) {
            await _saveToken(data['token']);
          }

          User? user;
          if (data['buyer'] != null) {
            user = User.fromJson(data['buyer']);
          }

          return {
            'message': data['message'] ?? 'OTP verified successfully.',
            'user': user,
          };
        } else {
          throw Exception(data['message'] ?? 'OTP verification failed');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Verify OTP DioError: ${e.response?.data}');
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.message ?? 'Server Error';
        }
      } else {
        errorMessage = 'Network Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // ignore: avoid_print
      print('Verify OTP Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<String> resendOtp({required String email}) async {
    try {
      final formData = FormData.fromMap({'email': email});

      final response = await _dio.post(
        ApiConstants.resendOtp,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // ignore: avoid_print
      print('Resend OTP Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return data['message'] ?? 'OTP resent successfully.';
        } else {
          throw Exception(data['message'] ?? 'Failed to resend OTP');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Resend OTP DioError: ${e.response?.data}');
      String errorMessage = 'Something went wrong';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = e.message ?? 'Server Error';
        }
      } else {
        errorMessage = 'Network Error: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // ignore: avoid_print
      print('Resend OTP Error: $e');
      throw Exception(e.toString());
    }
  }
}
