import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/myprojects/project_detailes.dart';
import '../basics/app_colors.dart';
import '../bottom_nav/bottom_nav.dart';
import '../chat/create_conversation_service.dart';
import '../native_service/secure_storage.dart';
import 'get_projects_controller.dart';

class MyProjectsScreen extends StatelessWidget {
  // final ProjectController controller = Get.put(ProjectController());
  final controller = Get.find<ProjectController>();
  final SecureStorage secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // نجيب أبعاد الشاشة
    final width = size.width;
    final height = size.height;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background_orange,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            centerTitle: true,
            title: Text(
              'مشاريعي',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
                fontSize: 18,),),
            elevation: 4, // يظهر ظل واضح
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          bottomNavigationBar: const CustomBottomBar(currentIndex: 1),

          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(     color: Color(0xfff77520), ));
            }

            if (controller.projectList.isEmpty) {
              return const Center(child: Text('لا يوجد مشاريع'));
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              itemCount: controller.projectList.length,
              itemBuilder: (context, index) {
                final project = controller.projectList[index];

                return Container(
                  height: height * 0.3,
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryColor, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage("assets/construction-site-59.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.projectName,
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "الشركة: ${project.companyName}",
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              Icons.star,
                              color: i < (project.rating ?? 0)
                                  ? Colors.amber
                                  : Colors.white24,
                              size: 22,
                            );
                          }),
                        ),

                        // 👇 يدفش الأزرار لتحت
                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.015,
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(() => ProjectDetailsScreen(projectId: project.id));
                                },
                                child: Text(
                                  "تفاصيل",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.015,
                                  ),
                                ),
                                onPressed: () async {
                                  final service = CreateConversationService();
                                  final result = await service
                                      .createConversation(project.employeeId);

                                  if (result != null) {
                                    Get.dialog(
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        title: Text(
                                          "نجاح",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.045,
                                          ),
                                        ),
                                        content: Text(
                                          "تمت إضافة المشرف بنجاح إلى قائمة محادثاتك.\nهل تريد الانتقال الآن إلى المحادثة؟",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: width * 0.04,
                                          ),
                                        ),
                                        actionsAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(
                                              "إلغاء",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: width * 0.04,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                              Get.toNamed('/conversationsList');
                                            },
                                            child: Text(
                                              "الانتقال",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: width * 0.04,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      barrierDismissible: false,
                                    );
                                  }
                                },
                                child: Text(
                                  "إنشاء محادثة",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                );
              },
            );
          }),
        ),

    );
  }
}