import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/signup/signup_service.dart';
import 'package:rebuild_flat/signup/verfiy_code_screen.dart';
import '../Routes/routes.dart';
import '../basics/app_colors.dart';
import '../native_service/secure_storage.dart';

class SignUpController extends GetxController {
  final SignUpService _service = SignUpService();
  final SecureStorage _secureStorage = SecureStorage();
  final isLoading = false.obs;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
    String? phone,
  }) async {
    isLoading.value = true;

    try {
      final result = await _service.register(
        name: name,
        email: email,
        password: password,
        age: age,
        gender: gender,
        phone: phone,
      );

      if (result['success'] == true) {
        final token = result['data']['token'] as String;
        await _secureStorage.save('token', token);
        print("Registration successful!");
        // Get.toNamed(AppRoutes.home);
        Get.to(VerifyCodeScreen());
      } else {
        _showErrorDialog(result);
      }
    } catch (e) {
      _showErrorDialog({'message': 'حدث خطأ عدل المعلومات المدخلة'});
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(Map<String, dynamic> response) {
    String message = response['message'] ?? 'فشل في التسجيل';

    if (response.containsKey('errors')) {
      final errors = response['errors'] as Map<String, dynamic>;

      final detailedErrors = errors.values
          .expand((list) => list)
          .cast<String>()
          .join('\n');

      if (detailedErrors.isNotEmpty) {
        message = detailedErrors;
      }
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('خطأ', style: TextStyle(fontWeight: FontWeight.bold,color:AppColors.primaryColor)),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('حسناً',style: TextStyle(color:AppColors.primaryColor ) ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}