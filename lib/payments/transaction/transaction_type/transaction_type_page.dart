import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/payments/transaction/transaction_type/transaction_type_controller.dart';
import '../../../basics/api_url.dart';
import '../../../basics/app_colors.dart';

class TransactionDetailsPage extends StatelessWidget {
  final int transactionId;
  final String type;

  TransactionDetailsPage({required this.transactionId, required this.type});

  final Map<String, IconData> iconMap = {
    "اسم المشروع": Icons.business,
    "المرحلة": Icons.timeline,
    "الحالة": Icons.info,
    "التاريخ": Icons.date_range,
    "رقم الطلب": Icons.receipt_long,
    "المبلغ": Icons.attach_money,
    "الطريقة": Icons.payment,
    "ملاحظة المشرف": Icons.note_alt,
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionDetailsController(
      transactionId: transactionId,
      type: type,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "تفاصيل المعاملة",
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
        fontSize: 18,)
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background_orange,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        final data = controller.details;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: AppColors.background_color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/undraw_online-banking.png",
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),

                    if (type == "StagePayment")
                      buildDetailsList([
                        {"label": "اسم المشروع", "value": data['project_name']},
                        {"label": "المرحلة", "value": data['stage_name']},
                        {"label": "الحالة", "value": data['status']},
                        {"label": "التاريخ", "value": data['date']},
                      ])
                    else if (type == "OrderPayment")
                      buildDetailsList([
                        {"label": "الحالة", "value": data['status']},
                        {"label": "التاريخ", "value": data['date']},
                      ])
                    else if (type == "TopUpRequest") ...[
                        buildDetailsList([
                          {"label": "المبلغ", "value": data['amount']},
                          {"label": "الطريقة", "value": data['method']},
                          {"label": "الحالة", "value": data['status']},
                          {"label": "ملاحظة المشرف", "value": data['admin_note'] ?? ''},
                          {"label": "التاريخ", "value": data['date']},
                        ]),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "صورة الإيصال",
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "${ServerConfiguration.domainNameServer}/storage/${data['receipt_image']}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                "لا يمكن تحميل الصورة",
                                style: GoogleFonts.cairo(fontSize: 16, color: Colors.red),
                              );
                            },
                          ),
                        ),
                      ]

                      else
                        Text(
                          "نوع المعاملة غير مدعوم",
                          style: GoogleFonts.cairo(fontSize: 18),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildDetailsList(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                iconMap[item['label']] ?? Icons.label,
                color: AppColors.primaryColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.cairo(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "${item['label']}: ",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: "${item['value'] ?? ''}",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
