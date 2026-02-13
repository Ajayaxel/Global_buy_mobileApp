import 'package:dio/dio.dart';
import 'package:global/constants/api_constants.dart';
import 'package:global/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository {
  final Dio _dio = Dio();

  OrderRepository() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        ApiConstants.getOrders,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final orderListResponse = OrderListResponse.fromJson(response.data);
        return orderListResponse.orders;
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Get Orders DioError: ${e.response?.data}');
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
      print('Get Orders Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<OrderModel> getOrderDetails(int orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        "${ApiConstants.getOrderDetails}$orderId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final orderDetailResponse = OrderDetailResponse.fromJson(response.data);
        return orderDetailResponse.order;
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Get Order Details DioError: ${e.response?.data}');
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
      print('Get Order Details Error: $e');
      throw Exception(e.toString());
    }
  }
}
