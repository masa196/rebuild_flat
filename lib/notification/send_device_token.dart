import 'dart:convert';
import 'package:http/http.dart' as http;

import '../basics/api_url.dart';
import '../native_service/secure_storage.dart';

class DeviceTokenService {
  final SecureStorage _secureStorage = SecureStorage();

  Future<void> sendDeviceToken(String deviceToken) async {
    try {
      // 1. اقرأ التوكين المخزن (Auth Token)
      final token = await _secureStorage.read('token');

      if (token == null) {
        print("❌ No auth token found in storage.");
        return;
      }

      // 2. جهز الـ body
      final body = {
        "device_token": deviceToken,
      };

      // 3. أرسل الطلب
      final response = await http.post(
        Uri.parse("${ServerConfiguration.domainNameServer}/api/create_device_token"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ Auth Bearer Token
        },
        body: jsonEncode(body),
      );

      // 4. فحص النتيجة
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Device token saved successfully");
      } else {
        print("❌ Failed to save token. Status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("🔥 Error sending device token: $e");
    }
  }
}
