import 'package:get/get.dart';
import 'package:rebuild_flat/payments/charge_money/payment_method_model.dart';
import 'package:rebuild_flat/payments/charge_money/payment_service.dart';
import '../../native_service/secure_storage.dart';

class PaymentController extends GetxController {
  var paymentMethods = <PaymentMethodModel>[].obs;
  late SecureStorage storage = SecureStorage();
  var isLoading = false.obs;
   String? token;



  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  void fetchPaymentMethods() async {
    try {
      isLoading(true);
      token = await storage.read('token');
      if (token != null) {
      final methods = await PaymentService.getPaymentMethods(token!);
      paymentMethods.assignAll(methods);
    }} catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
