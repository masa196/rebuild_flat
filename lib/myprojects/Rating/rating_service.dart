import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../basics/api_url.dart';
import '../../native_service/secure_storage.dart';


class ProjectRatingService {
  Future<bool> rateProject({required int projectId, required int rating}) async {
    final token = await SecureStorage().read('token');
    final url = '${ServerConfiguration.domainNameServer}/api/project/$projectId/rate';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rating': rating.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Rating failed: ${response.body}');
      return false;
    }
  }
}
class ProjectCommentService {
  Future<bool> addComment({required int projectId, required String comment}) async {
    final token = await SecureStorage().read('token');
    final url = '${ ServerConfiguration.domainNameServer}/api/project/$projectId/comment';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'comment': comment}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Comment failed: ${response.body}");
      return false;
    }
  }
}
