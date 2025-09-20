import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/signup/signup_controller.dart';
import '../basics/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _ctrl = Get.find<SignUpController>();


  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _gender;
  final _genders = ['ذكر', 'أنثى'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pad = size.width * 0.08;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background_orange,
        body: SafeArea(
          child: Obx(() {
            return AbsorbPointer(
              absorbing: _ctrl.isLoading.value,
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Image.asset('assets/workers-removebg-preview.png', height: 100),
                              Text('إنشاء حساب',
                                  style: TextStyle(color: AppColors.primaryColor, fontSize: 22, fontWeight: FontWeight.bold)),
                              Container(height: 3, width: 100, color: AppColors.primaryColor.withOpacity(0.7)),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              const SizedBox(height: 20),
                              _buildTextField(nameCtrl, 'الاسم', Icons.person),
                              _buildTextField(ageCtrl, 'العمر', Icons.cake, isNumber: true),
                              _buildDropdown(),
                              _buildTextField(emailCtrl, 'الإيميل', Icons.email, isEmail: true),
                              _buildTextField(passCtrl, 'كلمة السر', Icons.lock, obscure: _obscurePassword, toggle: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              }),
                              _buildTextField(confirmPassCtrl, 'تأكيد كلمة السر', Icons.lock, obscure: _obscureConfirm, toggle: () {
                                setState(() => _obscureConfirm = !_obscureConfirm);
                              }),
                              _buildTextField(phoneCtrl, 'رقم الهاتف (سوريا)', Icons.phone, isNumber: true),
                              const SizedBox(height: 30),
                              SizedBox(
                                height: size.height * 0.06,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _onSubmit,
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                  child: Text('إنشاء حساب',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_ctrl.isLoading.value)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String label, IconData icon,
      {bool obscure = false, bool isEmail = false, bool isNumber = false, VoidCallback? toggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(children: [Icon(icon, size: 18, color: AppColors.primaryColor), const SizedBox(width: 6), Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryColor))]),
        const SizedBox(height: 8),
        TextField(
          controller: c,
          obscureText: obscure,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : isNumber
              ? TextInputType.number
              : TextInputType.text,
          cursorColor: AppColors.primaryColor,
          decoration: InputDecoration(
            suffixIcon: toggle != null
                ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: obscure ? Colors.grey : AppColors.primaryColor), onPressed: toggle)
                : null,
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(children: [const Icon(Icons.wc, size: 18, color: AppColors.primaryColor), const SizedBox(width: 6), const Text('الجنس', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryColor))]),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _gender,
          items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g, textAlign: TextAlign.center))).toList(),
          onChanged: (v) => setState(() => _gender = v),
          decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor))),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  void _onSubmit() {
    if (passCtrl.text != confirmPassCtrl.text) {
      Get.snackbar('خطأ', 'كلمتا المرور غير متطابقتين');
      return;
    }

    _ctrl.register(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
      age: int.tryParse(ageCtrl.text.trim()) ?? 0,
      gender: _gender ?? '',
      phone: phoneCtrl.text.trim(),
    );
  }
}
