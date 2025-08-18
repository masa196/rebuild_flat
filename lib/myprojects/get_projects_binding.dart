import 'package:get/get.dart';
import 'get_projects_controller.dart';

class GetProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectController>(() => ProjectController());
  }
}
