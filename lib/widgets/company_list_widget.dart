import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../search/search_controller.dart';
import 'company_card.dart';

class CompanyListWidget extends StatelessWidget {
  const CompanyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MySearchController controller = Get.find();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Obx(() {
      // عرض مؤشر تحميل عندما لا توجد بيانات بعد
      if (controller.isLoading.value && controller.companies.isEmpty) {
        return const Center(child: CircularProgressIndicator( color: Color(0xfff77520), ));
      }

      // ✅ الشرط الجديد: عرض رسالة إذا البحث مفعل ولا توجد نتائج
      if (!controller.isLoading.value &&
          controller.query.value.isNotEmpty &&
          controller.companies.isEmpty) {
        return const Center(child: Text('لا توجد نتائج مطابقة للبحث'));
      }

      // الحالة الأصلية: لا يوجد بحث مفعل، ولا توجد شركات
      if (!controller.isLoading.value &&
          controller.query.value.isEmpty &&
          controller.companies.isEmpty) {
        return const Center(child: Text('لا توجد شركات متاحة حالياً'));
      }

      // عرض النتائج
      return Expanded(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الشركات:',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!controller.isLoading.value &&
                      scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                    controller.loadNextPage();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: controller.companies.length + (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.companies.length) {
                      final company = controller.companies[index];
                      return CompanyCard(companyModel: company);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
