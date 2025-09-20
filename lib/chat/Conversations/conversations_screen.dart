import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../basics/app_colors.dart';
import '../One_chat/chat_screen.dart';
import 'conversations_controller.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConversationController>();

    return Scaffold(
      backgroundColor: AppColors.background_orange,
      appBar: AppBar(
        centerTitle: true,
        title: Text("المحادثات",style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
          fontSize: 18,),),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Color(0xfff77520)));
        }

        if (controller.conversations.isEmpty) {
          return Center(child: Text("لا توجد محادثات"));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.conversations.length,
          itemBuilder: (context, index) {
            final conversation = controller.conversations[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => ChatScreen(
                  employee_id: conversation.employeeId,
                  customer_id: conversation.customerId,
                  conversation_id: conversation.id,
                ));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background_orange,
                      AppColors.primaryColor.withOpacity(0.2),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl, // 🟠 عكس الاتجاه
                  child: ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage("assets/engineer.png"),
                    ),
                    title: Row(
                      children: [
                        Text(
                          conversation.employee.firstName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkOrange,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            conversation.employee.lastName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.message,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
