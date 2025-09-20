import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Routes/routes.dart';
import '../basics/app_colors.dart';
import '../favourite/favourite_page.dart';
import '../logout/logout_controller.dart';
import '../myprojects/get_projects_screen.dart';
import '../payments/order_request/map.dart';
import '../payments/start_wallet_page.dart';
import '../payments/transaction/transaction_page.dart';
import '../profile/profile_page.dart';
import '../show_orders/show_orders_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final LogoutController logoutController = Get.find();

    return Drawer(
      backgroundColor: AppColors.background_orange,

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      "assets/engineer.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Crafty",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('الملف الشخصي'),
              onTap: () {
               // Get.to(MapPage());
               Get.toNamed(AppRoutes.profilepage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('المحادثات'),
              onTap: () {
                Get.toNamed(AppRoutes.conversationsList);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.precision_manufacturing),
            //   title: const Text('مشاريعي'),
            //   onTap: () {
            //     // Get.to(MyProjectsScreen());
            //     Get.toNamed(AppRoutes.projectpage);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.favorite_sharp),
              title: const Text('المفضلة'),
              onTap: () {
                // Get.to(FavoritePage());
                Get.toNamed(AppRoutes.favourite);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.wallet),
            //   title: const Text('المحفظة'),
            //   onTap: () {
            //     Get.to( StartWalletPage());
            //
            //     // Get.toNamed(AppRoutes.payment_methode);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.home_work_outlined),
              title: const Text('طلبات الكشف'),
              onTap: () {
                // Get.to(ShowOrdersPage());
                Get.toNamed(AppRoutes.showorders);
              },
            ),
            ListTile(
              leading: const Icon(Icons.padding),
              title: const Text('المعاملات'),
              onTap: () {
                // Get.to(TransactionsPage());
                Get.toNamed(AppRoutes.transaction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () {
                logoutController.logout();
              },
            ),

          ],

        ),
      ),
    );
  }
}
