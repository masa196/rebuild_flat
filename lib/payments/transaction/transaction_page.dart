import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'package:rebuild_flat/payments/transaction/transaction_controller.dart';
import 'package:rebuild_flat/payments/transaction/transaction_type/transaction_type_page.dart';

class TransactionsPage extends StatelessWidget {
  // final controller = Get.put(TransactionsController());
  final controller = Get.find<TransactionsController>();

  // ألوان وأيقونات لكل نوع معاملة
  final Map<String, dynamic> typeStyles = {
    "TopUpRequest": {
      "icon": Icons.account_balance_wallet,
      "color": AppColors.primaryColor,
      "label": "شحن المحفظة",
    },
    "StagePayment": {
      "icon": Icons.work,
      "color": AppColors.primaryColor,
      "label": "دفع كلفة مرحلة",
    },
    "OrderPayment": {
      "icon": Icons.shopping_cart,
      "color": AppColors.primaryColor,
      "label": "دفع كلفة طلب",
    },
    "default": {
      "icon": Icons.swap_horiz,
      "color": Colors.grey,
      "label": "معاملة",
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_orange,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          "المعاملات",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
              fontSize: 18,)
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.orange));
        }

        if (controller.transactions.isEmpty) {
          return Center(
              child: Text(
                "لا يوجد معاملات",
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final tx = controller.transactions[index];
            final type = tx['type'] ?? 'default';

            final iconData =
                typeStyles[type]?['icon'] ?? typeStyles['default']!['icon'];
            final colorData =
                typeStyles[type]?['color'] ?? typeStyles['default']!['color'];
            final label =
                typeStyles[type]?['label'] ?? typeStyles['default']!['label'];

            return InkWell(
              onTap: () {
                Get.to(() => TransactionDetailsPage(
                  transactionId: tx['id'],
                  type: tx['type'],
                ));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorData.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconData, color: colorData, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("من:",
                                      style: GoogleFonts.cairo(
                                          color: Colors.grey[600],
                                          fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text("إلى:",
                                      style: GoogleFonts.cairo(
                                          color: Colors.grey[600],
                                          fontSize: 13)),
                                ],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx['payer_name'] ?? '',
                                      style: GoogleFonts.cairo(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tx['receiver_name'] ?? '',
                                      style: GoogleFonts.cairo(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "فاتورة: ${tx['invoice_number']}",
                            style: GoogleFonts.cairo(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tx['date'] ?? '',
                            style: GoogleFonts.cairo(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "\$${tx['amount']}",
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            " details ",
                            style: GoogleFonts.cairo(
                                color: Colors.orange, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
