import 'package:dio/dio.dart';
import 'package:global/constants/api_constants.dart';
import 'package:global/models/chat_message_model.dart';
import 'package:global/models/chat_supplier_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  final Dio _dio = Dio();

  ChatRepository() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<ChatSupplier>> getChatList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        ApiConstants.chatList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // ignore: avoid_print
      print('Chat List Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final ChatListResponse chatListResponse = ChatListResponse.fromJson(
            data,
          );
          return chatListResponse.suppliers;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch chat list');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Chat List DioError: ${e.response?.data}');
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
      print('Chat List Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<List<ChatMessage>> getChatMessages(int supplierId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        '${ApiConstants.viewChat}$supplierId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // ignore: avoid_print
      print('View Chat Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final ChatMessagesResponse chatMessagesResponse =
              ChatMessagesResponse.fromJson(data);
          return chatMessagesResponse.chats;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch messages');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('View Chat DioError: ${e.response?.data}');
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
      print('View Chat Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<ChatMessage> sendMessage(int supplierId, String message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formData = FormData.fromMap({
        'supplier_id': supplierId,
        'message': message,
      });

      final response = await _dio.post(
        ApiConstants.sendMessage,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // ignore: avoid_print
      print('Send Message Response: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return ChatMessage.fromJson(data['chat']);
        } else {
          throw Exception(data['message'] ?? 'Failed to send message');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print('Send Message DioError: ${e.response?.data}');
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
      print('Send Message Error: $e');
      throw Exception(e.toString());
    }
  }
}
