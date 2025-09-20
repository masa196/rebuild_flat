import 'package:get/get.dart';
import 'package:rebuild_flat/show_orders/show_order_service.dart';
import 'package:rebuild_flat/show_orders/show_orders_model.dart';

class ShowOrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <ShowOrder>[].obs;

  final ShowOrderService orderService = ShowOrderService();

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  void fetchOrders() async {
    try {
      isLoading(true);
      var fetchedOrders = await orderService.fetchOrders();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
