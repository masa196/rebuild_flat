import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes/routes.dart';
import '../basics/app_colors.dart';
import '../login/login_binding.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/get_started-removebg-preview.png',
      'title': 'مرحباً بك في كرافتي!',
      'subtitle': 'اعثر على خدمات إكساء! جدّد شقتك لحلة جديدة',
    },
    {
      'image': 'assets/get_started_1-removebg-preview.png',
      'title': 'التتبع خطوة بخطوة!',
      'subtitle': 'تابع مراحل الإكساء وشاهد تطورات الشقة وأنت في المنزل',
    },
    {
      'image': 'assets/get_started_2-removebg-preview.png',
      'title': 'الدفع على دفعات!',
      'subtitle': 'دفع إلكتروني آمن مع إمكانية دفع الفواتير على دفعات',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background_orange,

        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.03,
          ),
          child: Column(
            children: [
              Spacer(flex: 1),

              Expanded(
                flex: 6,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          page['title']!,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Expanded(
                          child: Image.asset(
                            page['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pages.length,
                                (dotIndex) => _buildDot(dotIndex == _currentPage),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Spacer(flex: 1),

              Column(
                children: [
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.login);  },
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white,                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.signup);


                      },
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white,                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Spacer(flex: 1),
            ],
          ),

        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.black45,
        shape: BoxShape.circle,
      ),
    );
  }
}