import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rebuild_flat/basics/app_colors.dart';
import '../basics/api_url.dart';
import '../native_service/secure_storage.dart';
import 'create_conversation_model.dart';

class CreateConversationService {
  final SecureStorage secureStorage = SecureStorage();

  Future<CreateConversationModel?> createConversation(int employeeId) async {
    try {
      final token = await secureStorage.read("token");
      final url = Uri.parse(
        "${ServerConfiguration.domainNameServer}/api/conversations",
      );

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"employee_id": employeeId}),
      );

      if (response.statusCode == 201 || response.statusCode==200) {
        Get.snackbar(
          "نجاح",
          " تمت اضافة المشرف بنجاح",
          backgroundColor: AppColors.primaryColor,
          colorText: Get.theme.snackBarTheme.contentTextStyle?.color ??
              const Color.fromARGB(255, 255, 255, 255),
        );
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // ✅ يرجع الموديل الجديد
        return CreateConversationModel.fromJson(jsonData);

      } else {
        Get.snackbar(
          "خطأ",
          "تعذر إضافة المشرف (الكود: ${response.statusCode})",
          backgroundColor: AppColors.primaryColor,
          colorText: Get.theme.snackBarTheme.contentTextStyle?.color ??
              const Color.fromARGB(255, 255, 255, 255),
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        "استثناء",
        "حدث خطأ: $e",
        backgroundColor: AppColors.primaryColor,
        colorText: Get.theme.snackBarTheme.contentTextStyle?.color ??
            const Color.fromARGB(255, 255, 255, 255),
      );
      return null;
    }
  }
}
