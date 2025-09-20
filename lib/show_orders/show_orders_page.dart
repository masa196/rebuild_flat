import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../basics/api_url.dart';
import '../basics/app_colors.dart';
import 'show_orders_controller.dart';

class ShowOrdersPage extends StatelessWidget {
  const ShowOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final ShowOrderController controller = Get.put(ShowOrderController());
    final controller = Get.find<ShowOrderController>();

    return Scaffold(
      backgroundColor: AppColors.background_orange,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          "طلباتي",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
              fontSize: 18,)
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Text(
              "لا توجد طلبات",
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];

            return Container(
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة الشركة
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        "${ServerConfiguration.domainNameServer}/storage/${order.company.logo}",
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image, size: 40),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // تفاصيل الطلب
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.company.name,
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              // الحالة كـ Container ملون
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  order.status, // رح يطلع "waiting"
                                  style: GoogleFonts.cairo(
                                    color: AppColors.primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "الكلفة: ${order.costOfExamination} ل.س",
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "الهاتف: ${order.company.phone}",
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "الموقع: ${order.company.location ?? 'غير محدد'}",
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
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
