import 'package:get/get.dart';
import 'package:rebuild_flat/notification/show_notification/show_not_model.dart';
import 'package:rebuild_flat/notification/show_notification/show_not_service.dart';

class ShowNotificationController extends GetxController {
  var isLoading = true.obs;
  var notifications = <ShowNotificationModel>[].obs;

  final ShowNotificationService notificationService = ShowNotificationService();

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void fetchNotifications() async {
    try {
      isLoading(true);
      var fetched = await notificationService.fetchNotifications();
      notifications.assignAll(fetched);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAll() async {
    try {
      await notificationService.deleteAllNotifications();
      notifications.clear(); // تفريغ القائمة محلياً

    } catch (e) {
      Get.snackbar("خطأ", "فشل في حذف الإشعارات",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
