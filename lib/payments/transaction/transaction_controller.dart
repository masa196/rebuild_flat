import 'package:get/get.dart';
import 'package:rebuild_flat/payments/transaction/transection_service.dart';

class TransactionsController extends GetxController {
  var transactions = [].obs;
  var isLoading = false.obs;
  final TransactionsService service = TransactionsService();

  @override
  void onInit() {
    fetchTransactions();
    super.onInit();
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading(true);
      final data = await service.getTransactions();
      transactions.value = data;
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      isLoading(false);
    }
  }
}
