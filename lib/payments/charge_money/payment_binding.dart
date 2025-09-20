import 'package:get/get.dart';
import 'package:rebuild_flat/payments/charge_money/payment_controller.dart';


class PaymentsMethodsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController(),
    );
  }
}
