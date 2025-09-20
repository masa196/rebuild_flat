import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rebuild_flat/notification/show_notification/show_not_model.dart';
import '../../basics/api_url.dart';
import '../../native_service/secure_storage.dart';

class ShowNotificationService {
  final SecureStorage secureStorage = SecureStorage();

  Future<List<ShowNotificationModel>> fetchNotifications() async {
    final token = await secureStorage.read("token");

    final response = await http.get(
      Uri.parse("${ServerConfiguration.domainNameServer}/api/notifications"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final notificationsJson = data['data'] as List;
      return notificationsJson
          .map((e) => ShowNotificationModel.fromJson(e))
          .toList();
    } else {
      throw Exception("فشل في جلب الإشعارات");
    }
  }

}
extension DeleteAll on ShowNotificationService {
  Future<void> deleteAllNotifications() async {
    final token = await secureStorage.read("token");

    final response = await http.get(
      Uri.parse("${ServerConfiguration.domainNameServer}/api/destroy"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("فشل في حذف الإشعارات");
    }
  }
}

