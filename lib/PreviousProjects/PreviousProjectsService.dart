import 'dart:convert';
import 'package:http/http.dart' as http;
import '../basics/api_url.dart';
import 'PreviousProjectsModel.dart';


class ProjectService {
  Future<List<PreviousProjectsModel>> fetchProjectsByCompanyId(
      String token, int companyId) async {
    final response = await http.get(
      Uri.parse("${ServerConfiguration.domainNameServer}/api/companies/$companyId/projects"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);


      List projects = jsonData['data']['projects'];

      return projects
          .map((projectJson) => PreviousProjectsModel.fromJson(projectJson))
          .toList();
    } else {
      throw Exception("Failed to load projects");
    }
  }
}

