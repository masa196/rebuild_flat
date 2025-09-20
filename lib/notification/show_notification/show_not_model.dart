class ShowNotificationModel {
  final String id;
  final int objId;
  final String title;
  final String body;
  final String type;
  final String? readAt;
  final String createdAt;

  ShowNotificationModel({
    required this.id,
    required this.objId,
    required this.title,
    required this.body,
    required this.type,
    this.readAt,
    required this.createdAt,
  });

  factory ShowNotificationModel.fromJson(Map<String, dynamic> json) {
    return ShowNotificationModel(
      id: json['id'],
      objId: json['obj_id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      readAt: json['read_at'],
      createdAt: json['created_at'],
    );
  }
}
