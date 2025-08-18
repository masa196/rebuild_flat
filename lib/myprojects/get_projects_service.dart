import 'dart:convert';
import 'package:http/http.dart' as http;
import '../basics/api_url.dart';
import '../native_service/secure_storage.dart';
import 'get_projects_model.dart';

class ProjectService {
  final String baseUrl = '${ ServerConfiguration.domainNameServer}/api/projects/myProject';
  Future<List<Project>> fetchProjects() async {
    final storage = SecureStorage();
    final token = await storage.read('token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final projectsJson = data['data'] as List;

      return projectsJson.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<int?> fetchProjectRating(int projectId, String token) async {
    final url = Uri.parse("${ ServerConfiguration.domainNameServer}/api/projects/$projectId/my-review");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['review']?['rating'];
    } else {
      return null;
    }
  }
}
