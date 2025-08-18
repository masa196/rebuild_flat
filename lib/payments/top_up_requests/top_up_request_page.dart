import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rebuild_flat/basics/app_colors.dart';
import 'package:rebuild_flat/payments/top_up_requests/top_up_request_controller.dart';
import '../../basics/api_url.dart';

class TopUpRequestsPage extends StatelessWidget {
  final String imageBaseUrl =
      "${ServerConfiguration.domainNameServer}/storage/";

  String formatDate(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: Icon(icon, size: 16, color: AppColors.primaryColor),
            ),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 2),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopUpRequestsController());

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "طلبات شحن المحفظة",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.requests.isEmpty) {
            return Center(
              child: Text(
                "لا يوجد طلبات شحن",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(8),
            itemCount: controller.requests.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
            final request = controller.requests[index];
            final imageUrl = imageBaseUrl + (request["receipt_image"] ?? "");

            return Obx(() {
              final isExpanded = controller.expandedIndexes[index] ?? false;

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        imageUrl,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, __) => Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(Icons.attach_money,
                                    "المبلغ", "${request["amount"]} ل.س"),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: _buildInfoItem(Icons.payment,
                                    "طريقة الدفع", request["payment_method"]["name"]),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(Icons.receipt_long,
                                    "رقم الفاتورة", request["invoice_number"] ?? "لا يوجد"),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: _buildInfoItem(Icons.info_outline,
                                    "الحالة", request["status"]),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              controller.toggleExpanded(index);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isExpanded ? "إخفاء التفاصيل" : "عرض التفاصيل",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppColors.primaryColor,
                                )
                              ],
                            ),
                          ),
                          AnimatedCrossFade(
                            firstChild: SizedBox.shrink(),
                            secondChild: Column(
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(Icons.note,
                                          "ملاحظة الأدمن",
                                          request["admin_note"] ?? "لا يوجد"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(

                                          Icons.calendar_today,
                                          "تاريخ الطلب",
                                          formatDate(request["created_at"])),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 300),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          }
          );
        }),
      ),
    );
  }
}