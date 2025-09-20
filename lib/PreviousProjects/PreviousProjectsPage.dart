import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../PreviousProjects/PreviousProjectsModel.dart';
import '../basics/api_url.dart';
import '../basics/app_colors.dart';

class PreviousProjectsPage extends StatelessWidget {
  final PreviousProjectsModel project;

  const PreviousProjectsPage({super.key, required this.project});
  static const String baseImageUrl =
      '${ServerConfiguration.domainNameServer}/storage/';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.projectName, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
            fontSize: 18,)),
          backgroundColor:AppColors.primaryColor,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProjectDetailsCard(context),
            const SizedBox(height: 30),
            _buildImageSliderSection(
              context,
              title: 'الصور قبل الإعمار',
              images: project.projectImages
                  .map((img) => {'url': img.beforeImage, 'caption': img.caption})
                  .toList(),
            ),
            const SizedBox(height: 30),
            _buildImageSliderSection(
              context,
              title: 'الصور بعد الإعمار',
              images: project.projectImages
                  .map((img) => {'url': img.afterImage, 'caption': img.caption})
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailsCard(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context, project.projectName),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.date_range,
                'الفترة: من ${project.startDate} إلى ${project.endDate}'),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.info_outline, 'الحالة: ${project.status}'),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.attach_money,
                'التكلفة النهائية: ${project.finalCost} ر.س'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              'تفاصيل المشروع:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(project.description, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.orange),
        const SizedBox(width: 6),
        Flexible(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildImageSliderSection(
      BuildContext context, {
        required String title,
        required List<Map<String, String>> images,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color:AppColors.primaryColor),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 240,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: true,
          ),
          items: images.map((img) {
            final String imageUrl = '$baseImageUrl${img['url']}';
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
                                  Image.asset('assets/Dec1.jpg',
                                      fit: BoxFit.contain),
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
                            Image.asset(
                              'assets/Dec1.jpg',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  caption,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
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
}
