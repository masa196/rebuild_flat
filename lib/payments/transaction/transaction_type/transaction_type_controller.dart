import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../basics/api_url.dart';
import '../../../native_service/secure_storage.dart';

class TransactionDetailsController extends GetxController {
  var isLoading = true.obs;
  var details = {}.obs;

  final int transactionId;
  final String type;

  TransactionDetailsController({required this.transactionId, required this.type});

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      final storage = SecureStorage();
      String? token = await storage.read("token");

      final response = await http.get(
        Uri.parse("${ServerConfiguration.domainNameServer}/api/transactions/relatedSummary/$transactionId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        details.value = json.decode(response.body)['data'] ?? {};
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
