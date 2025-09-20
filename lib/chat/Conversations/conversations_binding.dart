import 'package:get/get.dart';

import 'conversations_controller.dart';


class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationController>(() => ConversationController());
  }
}
