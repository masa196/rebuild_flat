import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../basics/api_url.dart';
import '../../native_service/secure_storage.dart';
import 'get_messages_model.dart';


class GetMessageService {
  final SecureStorage storage = SecureStorage();

  Future<List<ChatMessage>> fetchMessages(int conversationId) async {
    try {
      String? token = await storage.read('token');
      if (token == null) throw Exception("⚠️ Token not found");

      final response = await http.get(
        Uri.parse("${ServerConfiguration.domainNameServer}/api/conversations/$conversationId/messages"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => ChatMessage.fromJson(item)).toList();
      } else {
        throw Exception("❌ Failed to load messages, status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("❌ Error fetching messages: $e");
    }
  }
}
