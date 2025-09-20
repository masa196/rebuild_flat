import 'package:get/get.dart';

import 'conversations_model.dart';
import 'conversations_service.dart';


class ConversationController extends GetxController {
  var conversations = <ConversationModel>[].obs;
  var isLoading = false.obs;

  final ConversationService _service = ConversationService();

  @override
  void onInit() {
    fetchConversations();
    super.onInit();
  }

  Future<void> fetchConversations() async {
    try {
      isLoading(true);
      final data = await _service.fetchConversations();
      conversations.assignAll(data);
    } catch (e) {
      Get.snackbar("خطأ", "فشل في تحميل المحادثات");
    } finally {
      isLoading(false);
    }
  }
}
