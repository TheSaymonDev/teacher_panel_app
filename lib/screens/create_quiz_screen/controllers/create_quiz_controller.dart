import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_details_controller.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/services/hive_service.dart';
import 'package:teacher_panel/services/notification_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class CreateQuizController extends GetxController {
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final topicNameController = TextEditingController();
  int selectedDuration = 10;
  final endTimeController = TextEditingController();
  DateTime? endTime;
  final subjectDetailsController = Get.find<SubjectDetailsController>();

  void updateDuration(int newDuration) {
    selectedDuration = newDuration;
    update();
  }

  Future<bool> createQuiz() async {
    final questions = HiveService().getQuestions();

    if (topicNameController.text.isEmpty) {
      AppConstFunctions.customErrorMessage(
          message: 'Topic name cannot be empty.');
      return false;
    }
    if (topicNameController.text.isNotEmpty && questions.length < 5) {
      AppConstFunctions.customErrorMessage(
          message: 'Minimum 5 questions are required to publish.');
      return false;
    }

    final formattedQuestions = questions.map((question) {
      return {
        'questionText': question.questionText,
        'options': question.options,
        'correctAnswer': question.correctAnswer,
      };
    }).toList();

    final response = await FirebaseService().createQuiz(
      classId: subjectDetailsController.classId,
      subjectId: subjectDetailsController.subjectId,
      topicName: topicNameController.text,
      timeDuration: selectedDuration.toString(),
      endTime: endTimeController.text,
      questions: formattedQuestions,
      subjectName: subjectDetailsController.subjectData.subjectName!
    );

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _sendNotification();
      Get.find<SubjectDetailsController>().refreshQuizzes();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void pickEndDateTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        endTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        endTimeController.text =
            AppConstFunctions.formatDateTime(endTime!); // Format করে দেখাও
        update();
      }
    }
  }

  void _sendNotification() async {
    final students = await FirebaseFirestore.instance
        .collection('classes')
        .doc(subjectDetailsController.classId)
        .collection('users')
        .get();

    print('📢 Found ${students.docs.length} students');

    for (final doc in students.docs) {
      final token = doc.data()['fcmToken'];
      print('🎯 Sending to token: $token');

      if (token != null) {
        await NotificationService().sendFcmHttpV1Notification(
          fcmToken: token,
          title: 'New Quiz Published!',
          body: '📚 ${topicNameController.text} is now live. Take the quiz before time ends!',
        );
      } else {
        print('❌ Token missing for user: ${doc.id}');
      }
    }
  }
}
