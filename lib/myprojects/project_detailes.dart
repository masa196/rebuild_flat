import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../basics/app_colors.dart';
import '../native_service/secure_storage.dart';
import '../basics/api_url.dart';
import '../project_stages/project_stages_screen.dart';
import 'Rating/rating_controller.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final int projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  Map<String, dynamic>? project;
  bool isLoading = true;
  final RatingController ratingController = Get.put(RatingController());

  @override
  void initState() {
    super.initState();
    fetchProjectDetails();
  }

  Future<void> fetchProjectDetails() async {
    final token = await SecureStorage().read('token');
    final url = '${ServerConfiguration.domainNameServer}/api/projects/myProject';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final allProjects = data['data'] as List;

        final selected = allProjects.firstWhere(
              (p) => p['id'] == widget.projectId,
          orElse: () => null,
        );

        if (selected != null) {
          setState(() {
            project = selected;
            isLoading = false;
          });
        }
      } else {
        throw Exception('فشل في تحميل البيانات');
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text("تفاصيل المشروع", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : project == null
            ? const Center(child: Text("لم يتم العثور على المشروع"))
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProjectDetailsCard(),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.timeline, size: 20,color: Colors.white,),
                label: const Text("مخطط مراحل المشروع", style: TextStyle(fontSize: 16,color: Colors.white)),
                onPressed: () {
                  Get.to(() => ProjectPhasesScreen(projectId: project!['id']));
                },
              ),
            ),
            const SizedBox(height: 16),
            /// أضفنا هذا:
            _buildRatingSection(),

            const SizedBox(height: 20),
            if (project!['file'] != null) ...[
              _buildPdfSection(project!['file']),
              const SizedBox(height: 24),
            ],
            if ((project!['project_images'] as List).isNotEmpty) ...[
              _buildImageSliderSection(
                title: 'الصور قبل الإعمار',
                isBefore: true,
              ),
              const SizedBox(height: 24),
              _buildImageSliderSection(
                title: 'الصور بعد الإعمار',
                isBefore: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildProjectDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 1.2),
        image: const DecorationImage(
          image: AssetImage("assets/construction-site-14.png"),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project!['project_name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.business, 'الشركة: ${project!['company_name']}'),
            _buildInfoRow(Icons.person, 'الموظف: ${project!['employee_name']}'),
            _buildInfoRow(Icons.info, 'الحالة: ${project!['status']}'),
            _buildInfoRow(Icons.date_range, 'الفترة: من ${project!['start_date']} إلى ${project!['end_date']}'),
            _buildInfoRow(Icons.timer, 'المدة: ${project!['duration_in_days']} يوم'),
            _buildInfoRow(Icons.attach_money, 'التكلفة: ${project!['final_cost']} ر.س'),
            const SizedBox(height: 10),
            const Text(
              'وصف المشروع:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              project!['description'],
              style: const TextStyle(fontSize: 14, color: Colors.white),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow(IconData icon, String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.white24,
          thickness: 0.8,
          height: 0,
          indent: 4,
          endIndent: 4,
        ),
      ],
    );
  }


  Widget _buildImageSliderSection({required String title, required bool isBefore}) {
    final List images = project!['project_images'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        const SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 240,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: true,
          ),
          items: images.map<Widget>((img) {
            final String imageUrl =
                '${ServerConfiguration.domainNameServer}/storage/${isBefore ? img['before_image'] : img['after_image']}';
            final String caption = img['caption'] ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.black,
                          insetPadding: const EdgeInsets.all(10),
                          child: InteractiveViewer(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/Dec1.jpg'),
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/Dec1.jpg', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  caption,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }).toList(),
        ),


      ],
    );
  }
  Widget _buildPdfSection(String filePath) {
    final pdfUrl = '${ServerConfiguration.domainNameServer}/storage/$filePath';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ملف المشروع:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.parse(pdfUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                Get.snackbar('خطأ', 'تعذر فتح الملف',
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
            label: const Text(
              'عرض / تحميل الملف',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildRatingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // زر التقييم
        SizedBox(
          height: 40,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.star, size: 18, color: Colors.white),
            label: const Text("قيّم المشروع", style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => _buildRatingDialog(),
              );
            },
          ),
        ),

        const SizedBox(width: 12), // المسافة بين الزرين

        // زر التعليق
        SizedBox(
          height: 40,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.comment, size: 18, color: Colors.white),
            label: const Text("أضف تعليق", style: TextStyle(fontSize: 14, color: Colors.white)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => _buildCommentDialog(),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildRatingDialog() {
    return Dialog(
      backgroundColor: AppColors.background_color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: 400,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "تقييم المشروع",
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Image.asset(
                    'assets/undraw_for-review_coua.png',
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final reversedIndex = 4 - index;
                          return IconButton(
                            icon: Icon(
                              Icons.star,
                              size: 30,
                              color: reversedIndex < ratingController.selectedRating.value
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              ratingController.selectedRating.value = 5 - index;
                            },
                          );
                        }),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  Obx(() {
                    return ratingController.isSubmitting.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () {
                        ratingController.submitRating(widget.projectId);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("إرسال التقييم", style: TextStyle(color: Colors.white)),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentDialog() {
    return Dialog(
      backgroundColor: AppColors.background_color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: 400,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "إضافة تعليق",
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Image.asset(
                    'assets/undraw_public-discussion.png',
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    onChanged: (val) => ratingController.commentText.value = val,
                    cursorColor: AppColors.primaryColor,
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقك هنا...',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
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
                  const SizedBox(height: 12),
                  Obx(() {
                    return ratingController.isSubmitting.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () {
                        ratingController.submitComment(widget.projectId);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("إرسال التعليق", style: TextStyle(color: Colors.white)),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}
