import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'package:rebuild_flat/payments/charge_money/payment_controller.dart';
import 'package:rebuild_flat/payments/charge_money/payment_method_model.dart';

import '../submit_top_up/top_up_page.dart';

class PaymentMethodsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentController>();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('شحن المحفظة'),
    backgroundColor:AppColors.primaryColor, // برتقالي ثابت
    elevation: 4, // يظهر ظل واضح
    centerTitle: true,
    ),

    body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),

              // ✅ صورة المحفظة مع خلفية دائرية
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade50,
                ),
                child: Image.asset(
                  'assets/img_1.png',
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 16),

              // ✅ النص التوضيحي
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:Text(
                  'إلى أي بطاقة تريد شحن رصيدك؟ اختر أحد الطرق وأدخل المعلومات المطلوبة هنا',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {

                      Get.to(() => TopUpPage());

                  },

                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: AppColors.primaryColor, // نفس لون التطبيق الأساسي
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'شحن المحفظة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ صندوق طرق الدفع
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 50,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ عنوان طرق الدفع
                    Text(
                      'طرق الدفع المتاحة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ✅ قائمة طرق الدفع
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.paymentMethods.length,
                      itemBuilder: (context, index) {
                        final method = controller.paymentMethods[index];
                        return PaymentMethodTile(method: method);
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}
class PaymentMethodTile extends StatefulWidget {
  final PaymentMethodModel method;

  PaymentMethodTile({required this.method});

  @override
  _PaymentMethodTileState createState() => _PaymentMethodTileState();
}

class _PaymentMethodTileState extends State<PaymentMethodTile> {
  bool isExpanded = false;

  String _getLogoPath(String name) {
    if (name.toLowerCase().contains('mtn')) return 'assets/img_3.png';
    if (name.toLowerCase().contains('syriatel')) return 'assets/img.png';
    if (name.toLowerCase().contains('haram')) return 'assets/img_2.png';
    return 'assets/icons/default.png';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _getLogoPath(widget.method.name),
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                widget.method.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ),

        // ✅ تفاصيل الطريقة
        if (isExpanded)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.method.instructions.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.orange),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${_translateKey(entry.key)}: ${entry.value}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ✅ ترجمة المفاتيح للعرض
  String _translateKey(String key) {
    switch (key) {
      case 'account':
        return 'رقم الحساب';
      case 'note':
        return 'ملاحظة';
      case 'branch':
        return 'الفرع';
      case 'name':
        return 'الاسم';
      case 'phone':
        return 'رقم الهاتف';
      default:
        return key;
    }
  }
}
