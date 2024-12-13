import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_details_controller.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/services/hive_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class CreateQuizController extends GetxController {
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final topicNameController = TextEditingController();
  int selectedDuration = 10;

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

    final subjectDetailsController = Get.find<SubjectDetailsController>();

    final response = await FirebaseService().createQuiz(
        classId: subjectDetailsController.classId,
        subjectId: subjectDetailsController.subjectId,
        topicName: topicNameController.text,
        timeDuration: selectedDuration.toString(),
        questions: formattedQuestions);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(
          message: 'Successfully Quiz Published');
      Get.find<SubjectDetailsController>().refreshQuizzes();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }
}
