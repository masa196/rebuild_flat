import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../basics/api_url.dart';
import '../../native_service/secure_storage.dart';
import 'objection.dart';

class ObjectionService {
  static Future<bool> sendObjection({
    required int stageId,
    required String text,
   }) async {
    final token = await SecureStorage().read('token');
    final url = '${ServerConfiguration.domainNameServer}/api/objections/create/$stageId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return true;
      } else {
        throw Exception(data['message'] ?? 'فشل في إرسال الاعتراض');
      }
    } else {
      throw Exception('حدث خطأ أثناء إرسال الاعتراض');
    }
  }

  static Future<List<ObjectionModel>> getObjectionsByStage(int stageId) async {
    final token = await SecureStorage().read('token');
    final url = '${ServerConfiguration.domainNameServer}/api/objections/stageObjections/$stageId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'] ?? [];

      return data.map((json) => ObjectionModel.fromJson(json)).toList();
    } else
      throw Exception('فشل في تحميل الاعتراضات');
    }
  }

