import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/notification/show_notification/show_not_controller.dart';
import '../../basics/app_colors.dart';

class ShowNotificationsPage extends StatelessWidget {
  const ShowNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final ShowNotificationController controller =
    // Get.put(ShowNotificationController());
    final controller = Get.find<ShowNotificationController>();

    return Scaffold(
      backgroundColor: AppColors.background_orange,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          "الإشعارات",
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

        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(
              "لا توجد إشعارات",
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
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];

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
                    // أيقونة
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.orange,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // محتوى الإشعار
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notif.title,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notif.body,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notif.createdAt,
                            style: GoogleFonts.cairo(
                              fontSize: 10,
                              color: Colors.grey[500],
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

      // ✅ زر الحذف يظهر فقط إذا في إشعارات
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        return controller.notifications.isEmpty
            ? const SizedBox.shrink()
            : FloatingActionButton.extended(
          backgroundColor: Colors.red,
          icon: const Icon(Icons.delete_forever, color: Colors.white),
          label: Text(
            "حذف الكل",
            style: GoogleFonts.cairo(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            controller.deleteAll();
          },
        );
      }),
    );

  }
}
