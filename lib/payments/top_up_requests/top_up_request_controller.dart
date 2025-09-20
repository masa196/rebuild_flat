import 'package:get/get.dart';
import 'package:rebuild_flat/native_service/secure_storage.dart';
import 'package:rebuild_flat/payments/top_up_requests/top_up_request_service.dart';
class TopUpRequestsController extends GetxController {
  var isLoading = false.obs;
  var requests = <dynamic>[].obs;

  // هنا نخزن حالة التوسيع لكل index
  var expandedIndexes = <int, bool>{}.obs;

  final storage = SecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading(true);
      String? token = await storage.read("token");
      if (token == null) throw Exception("لم يتم العثور على التوكن");

      final data = await TopUpRequestsService.fetchRequests(token);
      requests.assignAll(data);

      // بعد تحميل الطلبات نفرغ حالات التوسيع عشان كلها false بالبداية
      expandedIndexes.clear();
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // دالة لتبديل حالة التوسيع
  void toggleExpanded(int index) {
    bool current = expandedIndexes[index] ?? false;
    expandedIndexes[index] = !current;
  }
}