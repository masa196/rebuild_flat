import 'package:get/get.dart';
import 'package:rebuild_flat/payments/transaction/transaction_controller.dart';

class TransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionsController>(() => TransactionsController());
  }
}
