import 'dart:convert';

import 'package:http/http.dart' as http;

import '../basics/api_url.dart';


class ForgetPasswordService {
  static Future<String?> sendResetCode(String email) async {
    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/forgetPassword');

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        // يمكنك أيضًا استخدام jsonDecode(response.body) لو أردت الرسالة بالتفصيل
        return "تم إرسال الرمز إلى بريدك الإلكتروني.";
      } else {
        return "حدث خطأ. حاول مجددًا.";
      }
    } catch (e) {
      return "فشل الاتصال بالخادم.";
    }
  }
}

class CheckCodeService {
  static Future<String?> verifyCode(String code) async {
    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/checkCode');

    try {
      final response = await http.post(
        url,
        body: {
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        return "الرمز صحيح.";
      } else {
        return "رمز خاطئ أو منتهي.";
      }
    } catch (e) {
      return "فشل الاتصال بالخادم.";
    }
  }
}


class ResetPasswordService {
  static Future<String?> resetPassword(String code, String password) async {
    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/resetPassword');

    try {
      final response = await http.post(
        url,
        body: {
          'code': code,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json["data"]["token"];
        // يمكنك حفظ التوكن هنا إذا أردت
        return "تم إعادة تعيين كلمة المرور بنجاح";
      } else {
        return "فشل في تعيين كلمة المرور";
      }
    } catch (e) {
      return "فشل الاتصال بالخادم.";
    }
  }
}
