import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'package:rebuild_flat/native_service/secure_storage.dart';
import 'package:rebuild_flat/payments/submit_top_up/top_up_service.dart';

class TopUpController extends GetxController {
  var isLoading = false.obs;

  var amount = ''.obs;
  var invoiceNumber = ''.obs;
  var paymentMethodId = ''.obs;
  File? receiptImage;

  final storage = SecureStorage();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      receiptImage = File(pickedFile.path);

      // عرض رسالة نجاح
      Get.snackbar("نجاح", "تم اختيار الصورة بنجاح",
          snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.orange.shade100);

      update(); // لتحديث واجهة عرض الصورة
    }
  }

  Future<void> submitTopUp() async {
    if (amount.value.isEmpty || paymentMethodId.value.isEmpty || receiptImage == null) {
      Get.snackbar("خطأ", "يرجى ملء جميع الحقول واختيار صورة");
      return;
    }

    try {
      isLoading(true);
      String? token = await storage.read('token');
      if (token == null) throw Exception("Token غير موجود");

      bool success = await TopUpService.submitTopUp(
        token: token,
        amount: amount.value,
        receiptImage: receiptImage!,
        paymentMethodId: paymentMethodId.value,
        invoiceNumber: invoiceNumber.value,
      );

      if (success) {
        Get.defaultDialog(
          backgroundColor: AppColors.background_color,
          title: "",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // صورة نجاح
              Image.asset(
                'assets/img_1.png', // ضع مسار صورتك هنا
                width: 100,
                height: 100,
              ),
              SizedBox(height: 12),
              // عنوان
              Text(
                "نجاح العملية",
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              // نص التفاصيل
              Text(
                "تم طلب الشحن بنجاح\nبانتظار موافقة الأدمن ليتم شحن الرصيد",
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              // زر الإغلاق
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  foregroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  "حسناً",
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else {
        Get.snackbar("خطأ", "فشل في إرسال طلب الشحن");
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
