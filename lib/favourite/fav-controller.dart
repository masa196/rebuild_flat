import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../basics/api_url.dart';
import '../homepage/company_model.dart';
import '../native_service/secure_storage.dart';
import 'favourite_service.dart';

class FavoriteController extends GetxController {
  var favorites = <FavoriteItem>[].obs;
  var isLoading = true.obs;
  final SecureStorage storage = SecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    isLoading(true);
    final token = await storage.read('token');

    if (token == null) {
      isLoading(false);
      return;
    }

    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/favorites');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List items = jsonBody['data'];

      favorites.value = items.map((e) => FavoriteItem.fromJson(e)).toList();
    } else {
      print('فشل في جلب المفضلة: ${response.statusCode}');
    }

    isLoading(false);
  }
  Future<void> removeFromFavorites(int companyId) async {
    final token = await storage.read('token');
    if (token == null) return;

    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/companies/$companyId/favorite');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      favorites.removeWhere((item) => item.id == companyId);
      Get.snackbar('تم الحذف', 'تمت إزالة الشركة من المفضلة', backgroundColor: Colors.orange.shade100);
    } else {
      Get.snackbar('خطأ', 'فشل في الحذف', backgroundColor: Colors.red.shade100);
    }
  }

}
class FavoriteItem {
  final int id;
  final String name;
  final String location;
  final String logo;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.location,
    required this.logo,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      logo: json['logo'],
    );
  }
}

