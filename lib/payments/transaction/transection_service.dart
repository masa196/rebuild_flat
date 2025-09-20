import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../basics/api_url.dart';
import '../../native_service/secure_storage.dart';

class TransactionsService {
  final String baseUrl = "${ServerConfiguration.domainNameServer}/api/transactions";
  final SecureStorage secureStorage = SecureStorage();

  Future<List<dynamic>> getTransactions() async {
    String? token = await secureStorage.read('token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'] ?? [];
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
