import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Routes/routes.dart';
import '../basics/app_colors.dart';
import '../payments/start_wallet_page.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      backgroundColor: AppColors.primaryColor,
      color: Colors.black,
      activeColor: Colors.white,
      style: TabStyle.react, // فيك تجرب TabStyle.fixed / TabStyle.reactCircle ...
      items: const [
        TabItem(icon: Icons.home, title: 'الرئيسية'),
        TabItem(icon: Icons.work, title: 'مشاريعي'),
        TabItem(icon: Icons.wallet, title: 'المحفظة'),
      ],
      height: 55,
      curveSize: 65,
      initialActiveIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed(AppRoutes.home);
            break;
          case 1:
            Get.offAllNamed(AppRoutes.projectpage);
            break;
          case 2:
            Get.offAll(StartWalletPage());
            break;
        }
      },
    );
  }
}
