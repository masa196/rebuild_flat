import 'package:get/get.dart';
import 'package:rebuild_flat/notification/show_notification/show_not_controller.dart';

class ShowNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowNotificationController>(() => ShowNotificationController());
  }
}
