import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/utils/app_logger.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/data/services/hive_service.dart';
import 'package:teacher_panel/data/services/notification_service.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_details_controller.dart';

class CreateQuizController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final topicNameController = TextEditingController();
  final endTimeController = TextEditingController();

  int selectedDuration = 10;
  DateTime? endTime;
  bool isLoading = false;

  final SubjectDetailsController _subjectDetailsController = Get.find();

  void updateDuration(int newDuration) {
    selectedDuration = newDuration;
    update();
  }

  Future<void> pickEndDateTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;
    if (!context.mounted) return; // ✅ context validity check

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;
    if (!context.mounted) return; // ✅ context validity check

    endTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    endTimeController.text = AppConstFunctions.formatDateTime(endTime!);
    update();
  }

  Future<bool> createQuiz() async {
    final questions = HiveService().getQuestions();

    final validationMsg = _validateInput(questions);
    if (validationMsg != null) {
      AppConstFunctions.customErrorMessage(message: validationMsg);
      return false;
    }

    _setLoading(true);

    final formattedQuestions = questions.map((question) {
      return {
        'questionText': question.questionText,
        'options': question.options,
        'correctAnswer': question.correctAnswer,
      };
    }).toList();

    final response = await FirebaseService().createQuiz(
      classId: _subjectDetailsController.classId,
      subjectId: _subjectDetailsController.subjectId,
      topicName: topicNameController.text.trim(),
      subjectName: _subjectDetailsController.subjectData.subjectName ?? '',
      className: _subjectDetailsController.subjectData.className ?? '',
      timeDuration: selectedDuration.toString(),
      endTime: endTimeController.text,
      questions: formattedQuestions,
    );

    final isSuccess = response['success'] == true;
    final message = response['message'] ?? (isSuccess ? 'Quiz created' : 'Something went wrong');

    if (isSuccess) {
      AppConstFunctions.customSuccessMessage(message: message);
      _subjectDetailsController.refreshQuizzes();
      await _sendNotificationToStudents();
    } else {
      AppConstFunctions.customErrorMessage(message: message);
    }

    _setLoading(false);
    return isSuccess;
  }

  String? _validateInput(List questions) {
    if (topicNameController.text.trim().isEmpty) {
      return 'Topic name cannot be empty.';
    }
    if(endTimeController.text.isEmpty){
      return 'Exam end time cannot be empty.';
    }
    if (questions.length < 5) {
      return 'Minimum 5 questions are required to publish.';
    }
    return null;
  }

  Future<void> _sendNotificationToStudents() async {
    final studentsSnapshot = await FirebaseFirestore.instance
        .collection('classes')
        .doc(_subjectDetailsController.classId)
        .collection('users')
        .get();
AppLogger.logDebug(_subjectDetailsController.classId);
    for (final doc in studentsSnapshot.docs) {
      final token = doc.data()['fcmToken'];
      AppLogger.logInfo(token);
      if (token != null && token.toString().isNotEmpty) {
        await NotificationService().sendFcmHttpV1Notification(
          fcmToken: token,
          title: 'New Quiz Published!',
          body: '📚 ${topicNameController.text.trim()} is now live. Take the quiz before time ends!',
        );
      }
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
