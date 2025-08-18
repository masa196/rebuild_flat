import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'package:rebuild_flat/payments/charge_money/payment_controller.dart';
import 'package:rebuild_flat/payments/submit_top_up/top_up_controller.dart';

class TopUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopUpController());
    final paymentController = Get.find<PaymentController>();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('شحن المحفظة'),
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: GetBuilder<TopUpController>(
            builder: (_) => Obx(() => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            const SizedBox(height: 16),

            Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "اختر طريقة الدفع",
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: AppColors.primaryColor, // لون الليبل الأساسي
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: AppColors.primaryColor, // لون الليبل المرفوع
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: paymentController.paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method.id.toString(),
                    child: Text(method.name),
                  );
                }).toList(),
                onChanged: (val) => controller.paymentMethodId.value = val ?? '',
              ),
            ),

            SizedBox(height: 16),

            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                cursorColor: AppColors.primaryColor,
                keyboardType: TextInputType.number,
                onChanged: (val) => controller.amount.value = val,

                decoration: InputDecoration(
                labelText: "المبلغ",
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.grey[700]),
                floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              textAlign: TextAlign.right,
            ),
          ),

          SizedBox(height: 16),

          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              cursorColor: AppColors.primaryColor,
              onChanged: (val) => controller.invoiceNumber.value = val,
              decoration: InputDecoration(
                labelText: "رقم الفاتورة (اختياري)",
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.grey[700]),
                floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              textAlign: TextAlign.right,
            ),
          ),

          SizedBox(height: 16),

          // زر اختيار الصورة في الوسط مع لون الخط
          Center(
            child: ElevatedButton.icon(
              onPressed: () => controller.pickImage(),
              icon: Icon(Icons.image, color: AppColors.primaryColor),
              label: Text(
                "اختيار صورة الإيصال",
                style: TextStyle(color: AppColors.primaryColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: BorderSide(color: AppColors.primaryColor),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          // عرض الصورة في الوسط
          if (controller.receiptImage != null)
      Center(

      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "تم اختيار الصورة: ${controller.receiptImage!.path.split('/').last}",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        SizedBox(height: 8),
        Image.file(controller.receiptImage!, height: 120),
      ],
    ),
    ),

    SizedBox(height: 16),

    controller.isLoading.value
    ? Center(child: CircularProgressIndicator())
        : ElevatedButton(
    onPressed: () => controller.submitTopUp(),
    style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
    child: Center(
    child: Text(
    "إرسال الطلب",
    style: TextStyle(fontSize: 16,color: Colors.white),
    )),
    ),
    ],
    ),
    )),
    ),
    ),
    );
  }
}