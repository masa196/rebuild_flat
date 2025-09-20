import 'package:get/get.dart';
import 'package:rebuild_flat/show_orders/show_orders_controller.dart';

class ShowOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowOrderController>(() => ShowOrderController());
  }
}
