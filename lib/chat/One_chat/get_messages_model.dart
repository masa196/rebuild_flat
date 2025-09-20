class ChatMessage {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderType;
  final String senderName;
  final String? senderImage;
  final String message;
  final String createdAt;
  final String updatedAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderType,
    required this.senderName,
    this.senderImage,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      senderType: json['sender_type'],
      senderName: json['sender_name'],
      senderImage: json['sender_image'],
      message: json['message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
