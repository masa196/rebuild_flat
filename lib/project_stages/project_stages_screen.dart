import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/project_stages/phases_timeline.dart';
import 'package:rebuild_flat/project_stages/project_stage_controller.dart';
import '../basics/app_colors.dart';

class ProjectPhasesScreen extends StatelessWidget {
  final int projectId;

  const ProjectPhasesScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectStageController(projectId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background_orange,

        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title:  Text(
            "مراحل المشروع",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
              fontSize: 18,
            ),          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 5,
          centerTitle: true,

        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Color(0xfff77520)));
          }

          if (controller.stages.isEmpty) {
            return const Center(child: Text("لا توجد مراحل لهذا المشروع"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.sortedStages.length,
            itemBuilder: (context, index) {
              final stage = controller.sortedStages[index];

              // تحقق إذا كانت المرحلة السابقة منتهية
              final isPreviousFinished = index > 0 &&
                  controller.sortedStages[index - 1].status.toLowerCase() == 'finished';

              return TimelineStageItem(
                stage: stage,
                isFirst: index == 0,
                isLast: index == controller.sortedStages.length - 1,
                isPreviousStageFinished: isPreviousFinished,
              );
            },
          );
        }),
      ),
    );
  }
}