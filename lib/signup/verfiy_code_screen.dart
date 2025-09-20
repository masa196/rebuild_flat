import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/signup/verify_code_service.dart';
import '../Routes/routes.dart';
import '../basics/app_colors.dart';
import '../homepage/home_page_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _isResending = false;

  Future<void> _handleVerify() async {
    final code = _codeController.text.trim();

    if (code.length != 6) {
      setState(() => _error = "يجب أن يكون الرمز مكونًا من 6 أرقام");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final success = await AuthService.verifyCode(code);
      if (success) {
        Get.offAllNamed(AppRoutes.home);

      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResendCode() async {
    setState(() => _isResending = true);
    try {
      await AuthService.resendCode();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الكود مرة أخرى إلى بريدك الإلكتروني')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إعادة الإرسال: ${e.toString()}')),
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

        backgroundColor: AppColors.background_orange,
        appBar: AppBar(
          automaticallyImplyLeading:false,
centerTitle: true,
          title: const Text('التحقق من البريد',style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
        ),
        body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/undraw_mail-sent.png',
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                'تم إرسال رمز التحقق إلى بريدك الإلكتروني\nيرجى إدخال الرمز المكون من 6 أرقام',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                cursorColor: AppColors.primaryColor,

                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'رمز التحقق',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  labelStyle: const TextStyle(color: AppColors.primaryColor),
                ),

              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                onPressed: _isLoading ? null : _handleVerify,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('تأكيد',style: TextStyle(color: Colors.white )),),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: _isResending ? null : _handleResendCode,
                child: Text(
                  _isResending ? '... جارٍ الإرسال' : 'إعادة إرسال الكود',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
