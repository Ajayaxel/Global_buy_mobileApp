import 'package:dio/dio.dart';
import 'package:global/constants/api_constants.dart';
import 'package:global/models/buyer_home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final Dio _dio = Dio();

  HomeRepository() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<BuyerHomeResponse> getHomeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // Authorization header is optional for some home data, but likely required here since it's /buyer/home
      // If token is null, we might still want to try if the endpoint allows public access, but usually /buyer implies auth.
      // The user prompt shows "status: pending" in supplier, so maybe it's auth protected.
      // I'll assume token is needed.

      final options = Options(
        headers: token != null
            ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
            : {'Accept': 'application/json'},
      );

      final response = await _dio.get(ApiConstants.buyerHome, options: options);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return BuyerHomeResponse.fromJson(data);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch home data');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
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
      throw Exception(e.toString());
    }
  }
}
