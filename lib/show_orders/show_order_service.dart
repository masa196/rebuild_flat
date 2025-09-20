import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rebuild_flat/show_orders/show_orders_model.dart';
import '../basics/api_url.dart';
import '../native_service/secure_storage.dart';

class ShowOrderService {
  final SecureStorage secureStorage = SecureStorage();

  Future<List<ShowOrder>> fetchOrders() async {
    final token = await secureStorage.read("token");

    final response = await http.get(
      Uri.parse("${ServerConfiguration.domainNameServer}/api/my-orders"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final ordersJson = data['data']['orders'] as List;
      return ordersJson.map((e) => ShowOrder.fromJson(e)).toList();
    } else {
      throw Exception("فشل في جلب الطلبات");
    }
  }
}
