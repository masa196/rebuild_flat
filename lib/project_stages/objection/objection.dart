class ObjectionModel {
  final int id;
  final int stageId;
  final int customerId;
  final String text;
  final DateTime createdAt;

  ObjectionModel({
    required this.id,
    required this.stageId,
    required this.customerId,
    required this.text,
    required this.createdAt,
  });

  factory ObjectionModel.fromJson(Map<String, dynamic> json) {
    return ObjectionModel(
      id: json['id'],
      stageId: int.parse(json['project_stage_id'].toString()),
      customerId: json['customer_id'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
