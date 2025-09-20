// survey_binding.dart
import 'package:get/get.dart';
import 'cost/cost_binding.dart';
import 'survey_controller.dart';
import 'survey_service.dart';
class SurveyBinding extends Bindings {
  @override
  void dependencies() {
    final service = SurveyService();
    final controller = SurveyController(service);
    Get.put(controller);

    // ✅ صحّح القراءة
    final args = Get.arguments as Map<String, dynamic>;
    final serviceIds = (args['serviceIds'] as List).map((e) => e as int).toList();

    controller.loadSurveyQuestions(serviceIds);

    CostBinding().dependencies();
  }
}
