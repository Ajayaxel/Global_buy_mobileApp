import 'package:dio/dio.dart';
import 'package:global/constants/api_constants.dart';
import 'package:global/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  final Dio _dio = Dio();

  CartRepository() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<(List<CartItem>, int)> getCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        ApiConstants.getCart,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['cart'] != null) {
          final List itemsJson = data['cart']['items'] ?? [];
          final items = itemsJson
              .map((item) => CartItem.fromJson(item))
              .toList();
          final int cartId = data['cart']['id'] ?? 0;
          return (items, cartId);
        } else {
          return (<CartItem>[], 0);
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Get Cart DioError: ${e.response?.data}');
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
      print('Get Cart Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCartItem(int cartItemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.delete(
        "${ApiConstants.deleteCartItem}$cartItemId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return;
        } else {
          throw Exception(data['message'] ?? 'Failed to remove item');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Delete Cart Item DioError: ${e.response?.data}');
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
      print('Delete Cart Item Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> addToCart({
    required int productId,
    required int quantity,
    required double price,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Using FormData as shown in Postman screenshot
      final formData = FormData.fromMap({
        'product_id': productId,
        'quantity': quantity,
        'price': price,
      });

      final response = await _dio.post(
        ApiConstants.addToCart,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            // Dio sets multipart/form-data automatically when using FormData
          },
        ),
      );

      // ignore: avoid_print
      print('Add to Cart Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == true) {
          return;
        } else {
          throw Exception(data['message'] ?? 'Failed to add to cart');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Add to Cart DioError: ${e.response?.data}');
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
      print('Add to Cart Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formData = FormData.fromMap({
        'cart_item_id': cartItemId,
        'quantity': quantity,
      });

      final response = await _dio.post(
        ApiConstants.changeCartQuantity,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return;
        } else {
          throw Exception(data['message'] ?? 'Failed to update quantity');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Update Cart Quantity DioError: ${e.response?.data}');
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
      print('Update Cart Quantity Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> buyNow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.post(
        ApiConstants.buyNow,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return;
        } else {
          throw Exception(data['message'] ?? 'Failed to place order');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Buy Now DioError: ${e.response?.data}');
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
      print('Buy Now Error: $e');
      throw Exception(e.toString());
    }
  }
}
