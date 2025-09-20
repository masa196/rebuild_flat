import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/notification/notification_service.dart';
import 'Routes/routes.dart';
import 'basics/app_colors.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/notification/notification_service.dart';
import 'Routes/routes.dart';
import 'basics/app_colors.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMsg().initFcm();

  // ✅ إذا كان التطبيق مسكر وانفتح عن طريق الإشعار
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    Future.delayed(Duration.zero, () {
      Get.offAllNamed(AppRoutes.home); // غيريها حسب اللوجيك تبعك
    });
  }

  // ✅ إذا كان التطبيق بالخلفية وانضغط على الإشعار
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Get.offAllNamed(AppRoutes.home);  });

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crafty App',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Arial',
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
