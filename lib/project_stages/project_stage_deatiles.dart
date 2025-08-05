import 'package:flutter/material.dart';
import 'package:rebuild_flat/project_stages/project_stage_model.dart';
import '../basics/app_colors.dart';

class ProjectStageDetailScreen extends StatelessWidget {
  final ProjectStageModel stage;

  const ProjectStageDetailScreen({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topImageHeight = screenHeight * 0.35;
    final sheetInitialSize = (screenHeight - (topImageHeight - 50)) / screenHeight;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // ✅ صورة غلاف ثابتة من الأصول
            Container(
              height: topImageHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/construction-site-1-2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔙 زر الرجوع
            Positioned(
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.arrow_forward, color: AppColors.primaryColor, size: 25),
                ),
              ),
            ),

            // 📄 القائمة السفلية مع حواف برتقالية
            DraggableScrollableSheet(
              initialChildSize: sheetInitialSize,
              minChildSize: sheetInitialSize,
              maxChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // المقبض العلوي
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            "تفاصيل المرحلة: ${stage.stageName}",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildDetailRow("اسم الخدمة:", stage.serviceName),
                          _buildDetailRow("نوع الخدمة:", stage.serviceTypeName),
                          _buildDetailRow("الوصف:", stage.description ?? "لا يوجد وصف"),
                          _buildDetailRow("التكلفة:", "${stage.cost} ر.س"),
                          _buildDetailRow("الحالة:", stage.status),

                          const SizedBox(height: 20),
                          const Divider(),

                          // ✅ زرين: اعتراض و تأكيد
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    // تنفيذ الإجراء
                                  },
                                  child: const Text("اعتراض", style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    // تنفيذ الإجراء
                                  },
                                  child: const Text("تأكيد", style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            "صور المرحلة:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),

                          // ✅ الصور مع تكبير عند الضغط
                          stage.images.isNotEmpty
                              ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: stage.images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                        backgroundColor: Colors.transparent,

                                        child: InteractiveViewer(
                                    child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      stage.images[index],
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error, size: 40),
                                    ),
                                  ),
                                  ),
                                  ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    stage.images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error, size: 40),
                                  ),
                                ),
                              );
                            },
                          )
                              : const Text("لا توجد صور لهذه المرحلة"),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}