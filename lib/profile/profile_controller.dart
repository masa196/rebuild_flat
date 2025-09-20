import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/profile/profile_model.dart';
import 'profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _service = ProfileService();

  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchProfile();
      print(jsonEncode(data));
      final userData = data['data']?['user'];

      if (userData != null && userData is Map<String, dynamic>) {
        user.value = UserModel.fromJson(userData);
      } else {
        Get.snackbar('خطأ', 'بيانات المستخدم غير موجودة أو غير صالحة');
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> saveProfileUpdates([String? imagePath]) async {
    try {
      isLoading.value = true;

      final userData = user.value;
      if (userData == null) return;

      await _service.updateProfile(
        name: userData.name,
        age: userData.age,
        gender: userData.gender,
        phone: userData.phone,
        imagePath: imagePath,  // إرسال مسار الصورة
      );

      await loadProfile();

      Get.snackbar('تم التعديل', 'تم تحديث الملف الشخصي بنجاح',backgroundColor: Colors.orange.shade100);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String current, String newPass, String confirmPass) async {
    try {
      isLoading.value = true;
      await _service.changePassword(
        currentPassword: current,
        newPassword: newPass,
        confirmPassword: confirmPass,
      );
      Get.back();
      Get.snackbar('تم', 'تم تغيير كلمة المرور بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}
