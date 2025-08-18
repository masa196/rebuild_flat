import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'package:rebuild_flat/payments/top_up_requests/top_up_request_page.dart';

import '../Routes/routes.dart';

class StartWalletPage extends StatelessWidget {
  const StartWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحفظة'),
        backgroundColor:AppColors.primaryColor, // برتقالي ثابت
        elevation: 4, // يظهر ظل واضح
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // انتقل إلى صفحة إنشاء رحلة
                  Get.toNamed(AppRoutes.payment_methode);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 50),
                      ),
                    ],
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                  ),
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/img_1.png', width: 100, height: 100, fit: BoxFit.contain),
                      SizedBox(height: 8.0),
                      Text(' شحن المحفظة',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  // انتقل إلى صفحة عرض رحلي
                  // Get.toNamed(AppRoutes.payment_methode);
                  Get.to(TopUpRequestsPage());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 50),
                      ),
                    ],
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                  ),
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/img_1.png', width: 100, height: 100, fit: BoxFit.contain),
                      SizedBox(height: 8.0),
                      Text('  طلبات الشحن ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}