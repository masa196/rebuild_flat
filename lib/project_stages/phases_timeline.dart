import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rebuild_flat/project_stages/project_stage_deatiles.dart';
import 'package:rebuild_flat/project_stages/project_stage_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../basics/app_colors.dart';

class TimelineStageItem extends StatelessWidget {
  final ProjectStageModel stage;
  final bool isFirst;
  final bool isLast;
  final bool isPreviousStageFinished;

  const TimelineStageItem({
    super.key,
    required this.stage,
    this.isFirst = false,
    this.isLast = false,
    this.isPreviousStageFinished = false,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (stage.status.toLowerCase()) {
      case "finished":
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case "in progress":
        icon = Icons.autorenew;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.radio_button_unchecked;
        iconColor = Colors.grey;
    }

    final bool isFinished = stage.status.toLowerCase() == "finished";

    // الخط الذي يسبق الدائرة يكون أخضر إذا كانت المرحلة السابقة منتهية
    final beforeLineColor = isPreviousStageFinished ? Colors.green : Colors.grey.withOpacity(0.3);

    // الخط الذي يلي الدائرة يكون أخضر إذا كانت هذه المرحلة منتهية
    final afterLineColor = isFinished ? Colors.green : Colors.grey.withOpacity(0.3);

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1,
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: beforeLineColor,
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: afterLineColor,
        thickness: 3,
      ),
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.background_orange,

            border: Border.all(
              color: isFinished ? Colors.green : iconColor,
              width: 3,
            ),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
      ),
      endChild: InkWell(
        onTap: () => Get.to(() => ProjectStageDetailScreen(stage: stage)),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stage.serviceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      stage.status.toLowerCase() == "finished"
                          ? "منتهية"
                          : stage.status.toLowerCase() == "preparing"
                          ? "لم تبدأ بعد"
                          : "قيد التنفيذ",
                      style: TextStyle(
                        fontSize: 12,
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "النوع: ${stage.serviceTypeName}",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              if (stage.description != null && stage.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  stage.description!,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                "التكلفة: ${stage.cost} ل.س",
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              if (stage.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    stage.images.first,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}