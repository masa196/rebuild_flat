import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../basics/app_colors.dart';
import 'splash_controller.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_orange,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/splashsreen-removebg-preview.png',
                height: 250,
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'Crafty',
                style: TextStyle(
                  fontSize: 30,
                  color:  AppColors.primaryColor,
                  fontFamily: 'Schuyler',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
