import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../PreviousProjects/PreviousProjectsController.dart';
import '../basics/app_colors.dart';
import '../homepage/company_model.dart';
import '../PreviousProjects/PreviousProjectsPage.dart';


class CompanyDetails extends StatelessWidget {
  final Company company;
  const CompanyDetails({super.key, required this.company});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topImageHeight = screenHeight * 0.35;
    final sheetInitialSize = (screenHeight - (topImageHeight - 50 )) / screenHeight;


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background_orange,

        body: Stack(
          children: [
            Container(
              height: topImageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage("assets/engineer.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // زر الرجوع للخلف
            Positioned(
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20,),
                ),
              ),
            ),

            // زر الرجوع للرئيسية
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () {

                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.home, color: Colors.white, size: 20),
                ),
              ),
            ),



            // القسم السفلي القابل للسحب
            DraggableScrollableSheet(
              initialChildSize: sheetInitialSize,
              minChildSize: sheetInitialSize,
              maxChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color:AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "اسم الشركة : ${company.name}",
                                  style: Theme.of(context).textTheme.titleMedium,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children:  [
                              Icon(Icons.location_on_outlined, size: 18, color: Colors.orange),
                              SizedBox(width: 8),
                              Text(" موقع الشركة : ${company.location }", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children:  [
                              Icon(Icons.phone_android, size: 18, color: Colors.orange),
                              SizedBox(width: 8),
                              Text("  رقم الهاتف للتواصل : ${company.phone }", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.monetization_on, size: 18, color: Colors.orange),
                              SizedBox(width: 8),
                              Text(
                                " تكلفة الفحص: ${company.costOfExamination} ل.س",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),

                          Text(
                            "نبذة عن الشركة",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            company.about,
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child:ElevatedButton(
                              onPressed: () async {
                                // تسجيل الكنترولر إن لم يكن مسجل مسبقًا
                                if (!Get.isRegistered<PreviousProjectsController>()) {
                                  Get.put(PreviousProjectsController());
                                }

                                // استدعاء التابع بعد تسجيل الكنترولر
                                _showProjectSelectionDialog(context, company.id);
                              },

                              child: const Text(
                                " مشاريع سابقة ",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),

                          const Divider(),


                          const Text(
                            "إذا أردت التواصل معنا، قم بتعبئة الاستبيان لمعرفة كم يكلف إعادة إعمار منزلك وستصلك الكلفة التقريبية مجانًا ومن ثم قدم طلبك:",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 15),

                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _showServiceSelectionDialog(context, company.services);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                              child: const Text(
                                "الاستبيان ",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "خدماتنا",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 15),

                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: company.services.length,
                              itemBuilder: (context, index) {
                                final service = company.services[index];
                                return _serviceCard(service);
                              },
                            ),
                          ),


                        ],
                      ),

                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(Service service) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: () {
          _showServiceDetailsDialog(service);
        },
        child: Column(
          children: [

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.home_repair_service, size: 40, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 90,
              child: Text(
                service.name,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

// تابع عرض تفاصيل الخدمة مع Animation
  void _showServiceDetailsDialog(Service service) {
    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "Service Details",
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink(); // لا نستخدمها هنا
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(service.name, textAlign: TextAlign.center),
            content: Text(service.description, textAlign: TextAlign.right),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("إغلاق"),
              ),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }


  void _showProjectSelectionDialog(BuildContext context, int companyId) async {
    final controller = Get.find<PreviousProjectsController>();


    final projects = await controller.fetchCompanyProjects(companyId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("المشاريع السابقة"),
          content: SizedBox(
            width: double.maxFinite,
            child: projects.isEmpty
                ? const Text("لا توجد مشاريع متاحة")
                : ListView.builder(
              shrinkWrap: true,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ListTile(
                    leading: const Icon(Icons.work, color: Colors.orange),
                    title: Text(project.projectName),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PreviousProjectsPage(project: project),
                        ),
                      );
                    }

                );
              },
            ),
          ),
        );
      },
    );
  }


  void _showServiceSelectionDialog(BuildContext context, List<Service> services) {
    List<Service> selectedServices = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("اختر الخدمات التي تحتاجها"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final isSelected = selectedServices.contains(service);

                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(service.name),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedServices.add(service);
                          } else {
                            selectedServices.remove(service);
                          }
                        });
                      },
                      activeColor: AppColors.primaryColor,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("إلغاء"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    if (selectedServices.isNotEmpty) {
                      Navigator.pop(context);
                      final serviceIds = selectedServices.map((e) => e.id).toList();

                      Get.toNamed('/survey', arguments: {
                        'companyId': company.id,
                        'serviceIds': serviceIds,
                      });                    } else {
                      Get.snackbar("تنبيه", "يرجى اختيار خدمة واحدة على الأقل",
                          backgroundColor: Colors.orange.shade100);
                    }
                  }

                  ,
                  child: const Text("التالي", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }


}
