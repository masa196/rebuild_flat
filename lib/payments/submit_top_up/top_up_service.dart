import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rebuild_flat/basics/api_url.dart';

class TopUpService {
  static Future<bool> submitTopUp({
    required String token,
    required String amount,
    required File receiptImage,
    required String paymentMethodId,
    required String invoiceNumber,
  }) async {
    final uri = Uri.parse('${ServerConfiguration.domainNameServer}/api/customer/submitTopUp');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['amount'] = amount;
    request.fields['payment_method_id'] = paymentMethodId;
    request.fields['invoice_number'] = invoiceNumber;
    request.files.add(await http.MultipartFile.fromPath(
      'receipt_image',
      receiptImage.path,
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      final jsonData = json.decode(resBody);
      return jsonData['success'] == true;
    } else {
      throw Exception("فشل إرسال طلب الشحن");
    }
  }
}
