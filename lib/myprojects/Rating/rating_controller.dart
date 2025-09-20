import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rating_service.dart';

class RatingController extends GetxController {
  var selectedRating = 0.obs;
  var isSubmitting = false.obs;
  var commentText = ''.obs;

  Future<void> submitRating(int projectId) async {
    if (selectedRating.value == 0) {
      Get.snackbar('تنبيه', 'يرجى اختيار تقييم أولاً');
      return;
    }

    isSubmitting.value = true;
    final success = await ProjectRatingService().rateProject(
      projectId: projectId,
      rating: selectedRating.value,
    );
    isSubmitting.value = false;

    if (success) {
      Get.snackbar('تم', 'تم إرسال التقييم بنجاح',backgroundColor: Colors.orange.shade100);
    } else {
      Get.snackbar('خطأ', 'فشل في إرسال التقييم',backgroundColor: Colors.orange.shade100);
    }
  }

  Future<void> submitComment(int projectId) async {
    if (commentText.value.trim().isEmpty) {
      Get.snackbar('تنبيه', 'يرجى كتابة تعليق أولاً',backgroundColor: Colors.orange.shade100);
      return;
    }

    isSubmitting.value = true;
    final success = await ProjectCommentService().addComment(
      projectId: projectId,
      comment: commentText.value.trim(),
    );
    isSubmitting.value = false;

    if (success) {
      Get.snackbar('تم', 'تم إرسال التعليق بنجاح',backgroundColor: Colors.orange.shade100);
      commentText.value = '';
    } else {
      Get.snackbar('خطأ', 'فشل في إرسال التعليق',backgroundColor: Colors.orange.shade100);
    }
  }
}
