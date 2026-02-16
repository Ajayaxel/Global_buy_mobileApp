import 'package:dio/dio.dart';
import 'package:global/constants/api_constants.dart';
import 'package:global/models/negotiation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NegotiationRepository {
  final Dio _dio = Dio();

  NegotiationRepository() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<NegotiationResponse> addNegotiation({
    required int cartId,
    required String negotiationPrice,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formData = FormData.fromMap({
        'cart_id': cartId,
        'negotiation_price': negotiationPrice,
      });

      final response = await _dio.post(
        ApiConstants.addNegotiation,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // ignore: avoid_print
      print('Add Negotiation Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == true) {
          return NegotiationResponse.fromJson(data);
        } else {
          throw Exception(data['message'] ?? 'Failed to add negotiation');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Add Negotiation DioError: ${e.response?.data}');
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
      print('Add Negotiation Error: $e');
      throw Exception(e.toString());
    }
  }
}
