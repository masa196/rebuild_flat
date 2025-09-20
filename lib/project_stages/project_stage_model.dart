// lib/models/project_stage_model.dart
import '../basics/api_url.dart';

class ProjectStageModel {
  final int id;
  final int projectId;
  final String stageName;
  final String serviceName;
  final String serviceTypeName;
  final String? description;
  final String status;
  final double cost;
  final List<String> images;
  final int isConfirmed;
  ProjectStageModel({
    required this.id,
    required this.projectId,
    required this.stageName,
    required this.serviceName,
    required this.serviceTypeName,
    required this.description,
    required this.status,
    required this.cost,
    required this.images,
    required this.isConfirmed
  });

  factory ProjectStageModel.fromJson(Map<String, dynamic> json) {
    final List imageList = json['image_stage'] ?? [];
    List<String> images = imageList.map<String>((img) {
      return "${ServerConfiguration.domainNameServer}/storage/${img['image']}";
    }).toList();

    return ProjectStageModel(
      id: json['id'],
      projectId: json['project_id'],
      stageName: json['stage_name'],
      serviceName: json['service_name'],
      serviceTypeName: json['service_type_name'],
      description: json['description'],
      status: json['status'],
      cost: (json['cost'] ?? 0).toDouble(),
      images: images,
      isConfirmed: json['is_confirmed'] ?? 0,
    );
  }
}
