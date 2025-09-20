import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../basics/app_colors.dart';
import 'chat_controller.dart';


class ChatScreen extends StatelessWidget {
  final employee_id;
  final customer_id;
  final conversation_id;
  final ScrollController _scrollController = ScrollController();

  ChatScreen({required this.employee_id, required this.customer_id, required this.conversation_id});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController(employee_id, customer_id, conversation_id));

    return Scaffold(
      backgroundColor: AppColors.background_orange,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'الدردشة',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
            fontSize: 18,),),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                }
              });
              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isAdminMessage = message['sender_type'] == 'employee';
                  final messageText = message['message'] ?? '';
                  final senderType = message['sender_type'] ?? '';
                  final senderName = message['sender_name'] ?? '';
                  final createdAt = message['created_at'] ?? '';

                  return Align(
                    alignment: isAdminMessage ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAdminMessage ? AppColors.background_orange : AppColors.background_color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(isAdminMessage ? 0 : 16),
                          bottomRight: Radius.circular(isAdminMessage ? 16 : 0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isAdminMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$senderType: $senderName',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isAdminMessage ? AppColors.darkOrange : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            messageText,
                            style: TextStyle(
                              color: isAdminMessage ? AppColors.darkOrange : Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            createdAt,
                            style: TextStyle(
                              fontSize: 12,
                              color: isAdminMessage ? AppColors.darkOrange.withOpacity(0.7) : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final messageText = chatController.messageController.text.trim();
                      if (messageText.isNotEmpty) {
                        chatController.sendMessage(messageText);
                        chatController.messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
