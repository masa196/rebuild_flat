import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'package:rebuild_flat/payments/charge_money/payment_controller.dart';
import 'package:rebuild_flat/payments/submit_top_up/top_up_controller.dart';

import '../../bottom_nav/bottom_nav.dart';

class TopUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopUpController());
    final paymentController = Get.find<PaymentController>();

    return Scaffold(
      backgroundColor: AppColors.background_orange,
      appBar: AppBar(
        title: Text(
          'شحن المحفظة',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
              fontSize: 18,)        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: GetBuilder<TopUpController>(
          builder: (_) => Obx(() => SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.shade50,
                    ),
                    child: Image.asset(
                      'assets/img_1.png',
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // النص التعريفي
                Center(
                  child: Text(
                    "ادخل المعلومات وأرفق الإيصال",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    decoration: _inputDecoration("اختر طريقة الدفع"),
                    items: paymentController.paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method.id.toString(),
                        child: Row(
                          children: [
                            Icon(Icons.payment,
                                color: AppColors.primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(method.name,
                                style: GoogleFonts.cairo()),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                    controller.paymentMethodId.value = val ?? '',
                  ),
                ),

                SizedBox(height: 12),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    cursorColor: AppColors.primaryColor,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => controller.amount.value = val,
                    decoration: _inputDecoration("المبلغ"),
                    style: GoogleFonts.cairo(),
                    textAlign: TextAlign.right,
                  ),
                ),

                SizedBox(height: 12),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    cursorColor: AppColors.primaryColor,
                    onChanged: (val) =>
                    controller.invoiceNumber.value = val,
                    decoration:
                    _inputDecoration("رقم الفاتورة"),
                    style: GoogleFonts.cairo(),
                    textAlign: TextAlign.right,
                  ),
                ),

                SizedBox(height: 16),

                // زر اختيار الصورة
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.pickImage(),
                    icon: Icon(Icons.image,
                        color: AppColors.primaryColor),
                    label: Text(
                      "اختيار صورة الإيصال",
                      style: GoogleFonts.cairo(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8),

                if (controller.receiptImage != null)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "تم اختيار الصورة: ${controller.receiptImage!.path.split('/').last}",
                          style: GoogleFonts.cairo(
                              color: AppColors.primaryColor),
                        ),
                        SizedBox(height: 8),
                        Image.file(controller.receiptImage!, height: 120),
                      ],
                    ),
                  ),

                SizedBox(height: 16),

                controller.isLoading.value
                    ? Center(child: CircularProgressIndicator(color: Color(0xfff77520)))
                    : ElevatedButton(
                  onPressed: () => controller.submitTopUp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text("إرسال الطلب",
                        style: GoogleFonts.cairo(
                            fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.cairo(color: Colors.orange),
      floatingLabelStyle: GoogleFonts.cairo(color: AppColors.primaryColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
