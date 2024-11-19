import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/services/hive_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class FirebaseQuestionController extends GetxController {
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final topicNameController = TextEditingController();
  int selectedDuration = 10;

  void updateDuration(int newDuration) {
    selectedDuration = newDuration;
    update();
  }

  /// Publish Questions to Firebase
  Future<bool> publishQuestionToFirebase() async {
    _setLoading(true);

    final questions = HiveService().getQuestions();

    if (questions.length < 5) {
      AppConstFunctions.customErrorMessage(
          message: 'Minimum 5 questions are required to publish.');
      _setLoading(false);
      return false;
    }

    // Map questions to Firebase format
    final formattedQuestions = questions.map((question) {
      return {
        'questionText': question.questionText,
        'options': question.options,
        'correctAnswer': question.correctAnswer,
      };
    }).toList();

    final response = await FirebaseService().publishQuestions(
      topicName: topicNameController.text,
      timeDuration: selectedDuration,
      questions: formattedQuestions,
    );

    _setLoading(false);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: 'Successfully Published');
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
