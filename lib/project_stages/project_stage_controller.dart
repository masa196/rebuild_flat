import 'package:get/get.dart';

import 'package:rebuild_flat/project_stages/project_stage_model.dart';
import 'package:rebuild_flat/project_stages/project_stage_service.dart';

class ProjectStageController extends GetxController {
  final int projectId;

  ProjectStageController(this.projectId);

  var stages = <ProjectStageModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStages();
  }

  Future<void> fetchStages() async {
    try {
      isLoading.value = true;
      final data = await ProjectStageService.fetchStages(projectId);
      stages.assignAll(data);
    } catch (e) {
      Get.snackbar("خطأ", "فشل في تحميل المراحل");
    } finally {
      isLoading.value = false;
    }
  }
  List<ProjectStageModel> get sortedStages {
    List<ProjectStageModel> finished = [];
    List<ProjectStageModel> inProgress = [];
    List<ProjectStageModel> preparing = [];

    for (var stage in stages) {
      final status = stage.status.toLowerCase();

      if (status == 'finished') {
        finished.add(stage);
      } else if (status == 'in progress') {
        inProgress.add(stage);
      } else if (status == 'preparing') {
        preparing.add(stage);
      } else {
        preparing.add(stage); // احتياطًا لأي حالة غير متوقعة
      }
    }

    return [...finished, ...inProgress, ...preparing];
  }

}
