import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/basics/app_colors.dart';


import '../basics/api_url.dart';
import '../company_details/company_details_view.dart';
import '../favourite/favourite_service.dart';
import '../homepage/company_model.dart';
import '../homepage/home_page_controller.dart';
import '../native_service/secure_storage.dart';

class CompanyCard extends StatefulWidget {
  final Company companyModel;

  const CompanyCard({super.key, required this.companyModel});

  @override
  State<CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  late bool isFavorited;
  final storage = SecureStorage();
  final FavoriteService favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    isFavorited = widget.companyModel.isFavorited;
  }

  void toggleFavorite() async {
    final token = await storage.read('token');
    if (token == null) return;

    final success = await favoriteService.toggleFavorite(widget.companyModel.id, token);
    if (success) {
      setState(() {
        isFavorited = !isFavorited;
      });
    } else {
      Get.snackbar('خطأ', 'فشل في تحديث المفضلة');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.03;
    final double radius = size.width * 0.09;
    final double fontSizeTitle = size.width * 0.035;
    final double fontSizeSubtitle = size.width * 0.025;
    final double iconSize = size.width * 0.05;
    final double spacing = size.width * 0.035;

    return GestureDetector(
      onTap: () {
        Get.to(() => CompanyDetails(company: widget.companyModel));
      },
      child: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(vertical: spacing),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.04),
          side: BorderSide(color: AppColors.primaryColor, width: size.width * 0.004),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                CircleAvatar(
                  radius: radius,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    '${ServerConfiguration.domainNameServer}/storage/${widget.companyModel.logo}',
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.companyModel.name,
                        style: TextStyle(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: spacing * 0.5),
                      Text(
                        widget.companyModel.location,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: fontSizeSubtitle,
                        ),
                      ),
                      SizedBox(height: spacing),
                      Row(
                        children: List.generate(5, (index) {
                          final rating = widget.companyModel.averageRating;
                          if (index < rating.floor()) {
                            return Icon(Icons.star, color: Colors.amber, size: iconSize);
                          } else if (index < rating && rating - index >= 0.5) {
                            return Icon(Icons.star_half, color: Colors.amber, size: iconSize);
                          } else {
                            return Icon(Icons.star_border, color: Colors.amber, size: iconSize);
                          }
                        }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                      size: iconSize + 10,
                    ),
                    onPressed: toggleFavorite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
