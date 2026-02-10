import 'package:dio/dio.dart';
import 'package:global/constants/api_constants.dart';
import 'package:global/models/buyer_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final Dio _dio = Dio();

  ProfileRepository() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<BuyerProfile> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        ApiConstants.getProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // ignore: avoid_print
      print('Get Profile Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          if (data['buyer'] != null) {
            return BuyerProfile.fromJson(data['buyer']);
          } else {
            throw Exception('Profile data not found in response');
          }
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch profile');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Get Profile DioError: ${e.response?.data}');
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
      print('Get Profile Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<BuyerProfile> updateProfile({
    required String fullName,
    required String companyName,
    required String email,
    required String phone,
    String? address,
    String? address2,
    String? avatarPath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final Map<String, dynamic> data = {
        'full_name': fullName,
        'company_name': companyName,
        'email': email,
        'phone': phone,
        'address': address ?? '',
        'address_2': address2 ?? '',
      };

      if (avatarPath != null && avatarPath.isNotEmpty) {
        data['avatar'] = await MultipartFile.fromFile(avatarPath);
      }

      final formData = FormData.fromMap(data);

      final response = await _dio.post(
        ApiConstants.getProfile,
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
      print('Update Profile Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          if (data['buyer'] != null) {
            return BuyerProfile.fromJson(data['buyer']);
          } else {
            throw Exception('Profile data not found in response');
          }
        } else {
          throw Exception(data['message'] ?? 'Failed to update profile');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Update Profile DioError: ${e.response?.data}');
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
      print('Update Profile Error: $e');
      throw Exception(e.toString());
    }
  }
}
