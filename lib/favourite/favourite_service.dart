import 'dart:convert';

import 'package:http/http.dart' as http;

import '../basics/api_url.dart';
import '../homepage/company_model.dart';

class FavoriteService {
  Future<bool> toggleFavorite(int companyId, String token) async {
    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/companies/$companyId/favorite');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    // إذا كان status 200 أو 201، نعتبره نجح
    return response.statusCode == 200 || response.statusCode == 201;
  }
  // جديد: جلب المفضلة
  Future<List<Company>> fetchFavorites(String token) async {
    final url = Uri.parse('${ServerConfiguration.domainNameServer}/api/favorites');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List companiesJson = decoded['data'];
      return companiesJson.map((e) => Company.fromJson(e)).toList();
    } else {
      throw Exception('فشل في جلب العناصر المفضلة');
    }
  }
}
