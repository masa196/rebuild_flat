import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rebuild_flat/project_stages/project_stage_model.dart';
import '../basics/app_colors.dart';
import 'objection/objection_controller.dart';
import 'objection/service_objection.dart';

class ProjectStageDetailScreen extends StatelessWidget {
  final ProjectStageModel stage;

  const ProjectStageDetailScreen({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topImageHeight = screenHeight * 0.35;
    final sheetInitialSize = (screenHeight - (topImageHeight - 50)) / screenHeight;
    final objectionController = Get.put(ObjectionController(stage.id));

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
                                  onPressed: () async {
                                    final TextEditingController objectionController = TextEditingController();

                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        final TextEditingController objectionController = TextEditingController();

                                        return Dialog(
                                          backgroundColor: AppColors.background_color,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                                                  minHeight: 200,
                                                  maxWidth: 400, // يمكن تعديله حسب الحجم المطلوب
                                                ),
                                                child: SingleChildScrollView(
                                                  padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                                                    top: 16,
                                                    right: 16,
                                                    left: 16,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Text("إرسال اعتراض", style: TextStyle(color:AppColors.primaryColor,fontSize: 18, fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 12),
                                                      Image.asset(
                                                        'assets/undraw_cancel_7zdh.png',
                                                        height: 150,
                                                      ),
                                                      const SizedBox(height: 16),
                                                      TextField(
                                                        controller: objectionController,
                                                        maxLines: 4,
                                                        cursorColor: Colors.orange,
                                                        decoration: InputDecoration(
                                                          hintText: "اكتب اعتراضك هنا",
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Colors.orange),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.grey.shade400),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          TextButton(
                                                            child: const Text("إلغاء",style: TextStyle(color: AppColors.primaryColor )),
                                                            onPressed: () => Navigator.pop(context),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: AppColors.primaryColor,
                                                            ),
                                                            child: const Text("إرسال", style: TextStyle(color: Colors.white)),
                                                            onPressed: () async {
                                                              final text = objectionController.text.trim();
                                                              if (text.isEmpty) return;

                                                              Navigator.pop(context);

                                                              try {
                                                                final success = await ObjectionService.sendObjection(
                                                                  stageId: stage.id,
                                                                  text: text,
                                                                );

                                                                if (success) {
                                                                  await Get.find<ObjectionController>().fetchObjections();
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    const SnackBar(content: Text('تم إرسال الاعتراض بنجاح')),
                                                                  );
                                                                }
                                                              } catch (e) {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text(e.toString())),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );

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
                          const SizedBox(height: 20),
                          const Text(
                            "الاعتراضات:",
                            style: TextStyle(color:AppColors.primaryColor,fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),

                          Obx(() {
                            if (objectionController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (objectionController.objections.isEmpty) {
                              return const Text("لا يوجد اعتراضات حتى الآن");
                            } else {
                              return ListView.builder(
                                itemCount: objectionController.objections.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final objection = objectionController.objections[index];
                                  final formattedDate = "${objection.createdAt.day.toString().padLeft(2, '0')}"
                                      "-${objection.createdAt.month.toString().padLeft(2, '0')}"
                                      "-${objection.createdAt.year}";
                                  final formattedTime = "${objection.createdAt.hour.toString().padLeft(2, '0')}"
                                      ":${objection.createdAt.minute.toString().padLeft(2, '0')}";

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9F9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.primaryColor, width: 1.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          objection.text,
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 14, color: AppColors.primaryColor),
                                            const SizedBox(width: 4),
                                            Text(
                                              "$formattedDate   $formattedTime",
                                              style: const TextStyle(fontSize: 12, color: AppColors.primaryColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          })


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