import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rebuild_flat/basics/api_url.dart';
import 'dart:convert';

import 'package:rebuild_flat/payments/charge_money/payment_method_model.dart';


class PaymentService {


  static Future<List<PaymentMethodModel>> getPaymentMethods(String token) async {
    final uri = Uri.parse('${ServerConfiguration.domainNameServer}/api/getPaymentMethods');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        List data = jsonData['data'];
        return data.map((e) => PaymentMethodModel.fromJson(e)).toList();
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      throw Exception('Failed to load payment methods');
    }
  }
}
