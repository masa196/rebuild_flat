import 'package:flutter/material.dart';
import '../basics/app_colors.dart';
import 'package:get/get.dart';

import '../homepage/home_page_screen.dart';
import 'forget_password_screen.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.find<LoginController>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingHorizontal = size.width * 0.08;

    return Directionality(
      textDirection: TextDirection.rtl,
      child:  Scaffold(
        backgroundColor: AppColors.background_orange,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),


                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/workers-removebg-preview.png',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 3,
                          width: 100,
                          color: AppColors.primaryColor.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Align(
                    alignment: Alignment.centerRight,
                    child:    Row(
                      children:  [
                        Icon(Icons.email, size: 18, color: AppColors.primaryColor),
                        SizedBox(width: 6),
                        Text(
                          'الإيميل',
                          style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.emailController,
                    cursorColor: AppColors.primaryColor,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerRight,
                    child:  Row(
                      children: const [
                        Icon(Icons.lock, size: 18, color: AppColors.primaryColor),
                        SizedBox(width: 6),
                        Text(
                          'كلمة السر',
                          style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.passwordController,

                    obscureText: _obscurePassword,
                    cursorColor: AppColors.primaryColor,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: _obscurePassword ? Colors.grey : AppColors.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),

                    ),
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => ForgetPasswordDialog(),
                      );
                    },

                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'هل نسيت كلمة السر ؟',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        controller.login();

                      },
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // const Text(
                  //   'أو يمكنك التسجيل عبر',
                  //   style: TextStyle(fontSize: 14, color: Colors.black54),
                  // ),
                  // const SizedBox(height: 15),
                  // GestureDetector(
                  //   onTap: () {
                  //
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.grey.shade300),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Image.asset(
                  //       'assets/google_logo.png',
                  //       height: 40,
                  //     ),
                  //   ),
                  // ),

                ],
              ),
            ),
          ),
        )

    );
  }
}
