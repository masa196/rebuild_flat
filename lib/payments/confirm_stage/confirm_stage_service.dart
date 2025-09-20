import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../basics/api_url.dart';

class StagePaymentService {
  static const String baseUrl = "${ServerConfiguration.domainNameServer}/api";
  static const storage = FlutterSecureStorage();

  static Future<bool> confirmStage(int stageId) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) throw Exception("المستخدم غير مسجل الدخول");

      final url = Uri.parse("$baseUrl/project-stages/confirmStage/$stageId");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true) {
          return true;
        } else {
          throw Exception(data["message"] ?? "حدث خطأ أثناء الدفع");
        }
      } else {
        throw Exception("فشل الاتصال بالسيرفر (${response.statusCode})");
      }
    } catch (e) {
      throw Exception("خطأ: $e");
    }
  }
}
