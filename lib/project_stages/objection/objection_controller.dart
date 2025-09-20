import 'package:get/get.dart';
import 'package:rebuild_flat/project_stages/objection/service_objection.dart';

import 'objection.dart';


class ObjectionController extends GetxController {
  final int stageId;

  ObjectionController(this.stageId);

  var objections = <ObjectionModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchObjections();
  }

  Future<void> fetchObjections() async {
    try {
      isLoading.value = true;
      final data = await ObjectionService.getObjectionsByStage(stageId);
      objections.assignAll(data);
    } catch (e) {
      Get.snackbar("خطأ", "فشل في تحميل الاعتراضات");
    } finally {
      isLoading.value = false;
    }
  }
}
