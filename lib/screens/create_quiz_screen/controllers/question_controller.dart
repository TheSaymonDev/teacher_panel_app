import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/services/hive_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/utils/question.dart';

class QuestionController extends GetxController {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  final questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
  List.generate(4, (_) => TextEditingController());

  final questions = <Question>[];

  int selectedCorrectAns = 0;

  void updateCorrectAns(int value) {
    selectedCorrectAns = value;
    update(); // Notify UI to update
  }

  // Fetch questions from Hive local database
  Future<void> getQuestionsFromLocalDb() async {
    _setLoading(true);
    try {
      final fetchedQuestions = HiveService().getQuestions();
      questions.assignAll(fetchedQuestions);
    } catch (error) {
      AppConstFunctions.customErrorMessage(
          message: 'Failed to fetch questions: $error');
    } finally {
      _setLoading(false);
    }
  }

  // Add question to Hive local database
  Future<void> addQuestionToLocalDb() async {
    try {
      final newQuestion = Question(
        questionText: questionController.text,
        options: optionControllers.map((controller) => controller.text.trim()).toList(),
        correctAnswer: selectedCorrectAns,
      );

      final response = await HiveService().addQuestion(newQuestion);
      if (response != null) {
        AppConstFunctions.customSuccessMessage(message: 'Question added successfully!');
        questions.add(newQuestion); // Update local list
        _clearFormFields();
        update();
      } else {
        AppConstFunctions.customErrorMessage(message: 'Failed to add question.');
      }
    } catch (error) {
      AppConstFunctions.customErrorMessage(message: error.toString());
    }
  }

  // Update question in Hive local database by index
  Future<void> updateQuestionByIndex(int index) async {
    try {
      final updatedQuestion = Question(
        questionText: questionController.text,
        options: optionControllers.map((controller) => controller.text.trim()).toList(),
        correctAnswer: selectedCorrectAns,
      );

      await HiveService().updateQuestion(index, updatedQuestion);
      questions[index] = updatedQuestion; // Update local list
      Get.back();
      AppConstFunctions.customSuccessMessage(message: 'Question updated successfully!');
      _clearFormFields();
      update();
    } catch (error) {
      AppConstFunctions.customErrorMessage(message: error.toString());
    }
  }

  // Delete question from Hive local database by index
  Future<void> deleteQuestionByIndex(int index) async {
    try {
      await HiveService().deleteQuestion(index);
      questions.removeAt(index); // Remove from local list
      AppConstFunctions.customSuccessMessage(message: 'Question deleted successfully!');
      update();
    } catch (error) {
      AppConstFunctions.customErrorMessage(message: 'Failed to delete question: $error');
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    update(); // Notify UI to update
  }

  // Clear all form fields after successfully adding/updating a question
  void _clearFormFields() {
    questionController.clear();
    for (var controller in optionControllers) {
      controller.clear();
    }
    selectedCorrectAns = 0;
    update();
  }

}
