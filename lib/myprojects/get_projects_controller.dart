import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'get_projects_model.dart';
import 'get_projects_service.dart';

class ProjectController extends GetxController {
  var isLoading = true.obs;
  var projectList = <Project>[].obs;

  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  void loadProjects() async {
    try {
      isLoading(true);
      var projects = await ProjectService().fetchProjects();

      // Get token from storage
      String? token = await _storage.read(key: "token");

      if (token != null) {
        for (var project in projects) {
          int? rating = await ProjectService().fetchProjectRating(project.id, token);
          project.rating = rating;
        }
      }

      projectList.assignAll(projects);
    } catch (e) {
      print('Error loading projects: $e');
    } finally {
      isLoading(false);
    }
  }
}