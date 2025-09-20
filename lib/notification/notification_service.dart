import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'send_device_token.dart';

class FirebaseMsg {
 final msgService = FirebaseMessaging.instance;

 Future<void> initFcm() async {
  await msgService.requestPermission();

  var token = await msgService.getToken();
  print("📱 FCM token: $token");

  if (token != null) {
   // 🔹 ابعت التوكين للسيرفر
   await DeviceTokenService().sendDeviceToken(token);
  }

  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
  FirebaseMessaging.onMessage.listen(handleNotification);
 }
}

// 👇 مخصص للـ background
Future<void> handleBackgroundNotification(RemoteMessage msg) async {
 print("📩 (BG) Message received: ${msg.notification?.title}");
}

// 👇 مخصص للـ foreground
void handleNotification(RemoteMessage msg) {
 print("📩 (FG) Message received: ${msg.notification?.title}");

 if (msg.notification != null) {
  Get.dialog(
   AlertDialog(
    title: Text(msg.notification!.title ?? "تنبيه",style:  TextStyle(
     fontSize: 16,
     color: AppColors.primaryColor,
     fontWeight: FontWeight.bold,
    )),
    content: Text(msg.notification!.body ?? ""),
    actions: [
     TextButton(
      onPressed: () => Get.back(),
      child: Text("OK" ,style:  TextStyle(
       fontSize: 16,
       color: AppColors.primaryColor,
       fontWeight: FontWeight.bold,
      )),
     ),
    ],
   ),
  );
 }
}
