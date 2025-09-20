// order_model.dart
// order_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../native_service/secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../basics/api_url.dart';

class OrderAnswer {
  final int questionServiceId;
  final String answer;

  OrderAnswer({required this.questionServiceId, required this.answer});

  Map<String, dynamic> toJson() => {
    'question_service_id': questionServiceId,
    'answer': answer,
  };
}

class OrderRequest {
  final int companyId;
  final double latitude;
  final double longitude;
  final List<OrderAnswer> answers;

  OrderRequest({
    required this.companyId,
    required this.latitude,
    required this.longitude,
    required this.answers,
  });

  Map<String, dynamic> toJson() =>
      {
        'company_id': companyId,
        'latitude': double.parse(latitude.toStringAsFixed(4)),
        'longitude': double.parse(longitude.toStringAsFixed(4)),
        'answers': answers.map((a) => a.toJson()).toList(),
      };
}


class OrderResponse {
  final bool status;
  final String message;

  OrderResponse({required this.status, required this.message});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class OrderService {
  Future<OrderResponse> createOrder(String token, OrderRequest request) async {
    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/CrateOrder');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(request.toJson()),

    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");
      print(jsonEncode(request.toJson()));

      return OrderResponse.fromJson(data);

    } else {

      print("Response code: ${response.statusCode}");
      print(jsonEncode(request.toJson()));

      print("Response body: ${response.body}");

      throw Exception("فشل في إنشاء الطلب");
    }
  }
}
// order_controller.dart



class OrderController extends GetxController {
  final OrderService service;
  late SecureStorage storage = SecureStorage();
  String? token;

  var isLoading = false.obs;

  OrderController(this.service);

  Future<void> createOrder(OrderRequest request) async {
    try {
      isLoading.value = true;
      token = await storage.read('token');
      final result = await service.createOrder(token!, request);

      if (result.status) {
        Get.snackbar("تم", "تم إنشاء الطلب بنجاح",backgroundColor: Colors.orange.shade100);
        Get.offAllNamed('/home'); // رجع المستخدم للصفحة الرئيسية
      } else {
        Get.snackbar("خطأ", result.message);

      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

