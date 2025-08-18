import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../basics/api_url.dart';

class TopUpRequestsService {
  static const String baseUrl =
      "${ServerConfiguration.domainNameServer}/api/customer/top-up-requests";

  static Future<List<dynamic>> fetchRequests(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body["success"] == true && body["data"] != null) {
        return body["data"];
      } else {
        throw Exception(body["message"] ?? "فشل في جلب البيانات");
      }
    } else {
      throw Exception("خطأ في الاتصال: ${response.statusCode}");
    }
  }
}
