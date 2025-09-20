import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rebuild_flat/basics/api_url.dart';

import 'conversations_model.dart';


class ConversationService {

  final _storage = const FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String? token = await _storage.read(key: "token");

    final response = await http.get(
      Uri.parse("${ServerConfiguration.domainNameServer}/api/conversations"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((c) => ConversationModel.fromJson(c)).toList();
    } else {
      throw Exception("Failed to load conversations");
    }
  }
}
