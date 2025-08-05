import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/data/models/question.dart';
import 'package:teacher_panel/data/services/hive_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class QuestionController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
  List.generate(4, (_) => TextEditingController());

  final questions = <Question>[].obs;

  int selectedCorrectAnswer = 0;
  bool isLoading = false;

  // ------------------------ Update ------------------------
  void updateCorrectAnswer(int value) {
    selectedCorrectAnswer = value;
    update();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void _clearFormFields() {
    questionController.clear();
    for (var controller in optionControllers) {
      controller.clear();
    }
    selectedCorrectAnswer = 0;
    update();
  }

  // ------------------------ CRUD Operations ------------------------

  Future<void> getQuestionsFromLocalDb() async {
    _setLoading(true);
    try {
      final fetched = HiveService().getQuestions();
      questions.assignAll(fetched);
    } catch (e) {
      AppConstFunctions.customErrorMessage(
        message: 'Failed to fetch questions: $e',
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addQuestionToLocalDb() async {
    try {
      final question = _buildQuestionFromInput();

      final saved = await HiveService().addQuestion(question);
      if (saved != null) {
        questions.add(question);
        AppConstFunctions.customSuccessMessage(message: 'Question added successfully!');
        _clearFormFields();
        update();
      } else {
        AppConstFunctions.customErrorMessage(message: 'Failed to add question.');
      }
    } catch (e) {
      AppConstFunctions.customErrorMessage(message: e.toString());
    }
  }

  Future<void> updateQuestionByIndex(int index) async {
    try {
      final updated = _buildQuestionFromInput();

      await HiveService().updateQuestion(index, updated);
      questions[index] = updated;
      AppConstFunctions.customSuccessMessage(message: 'Question updated successfully!');
      _clearFormFields();
      Get.back();
      update();
    } catch (e) {
      AppConstFunctions.customErrorMessage(message: e.toString());
    }
  }

  Future<void> deleteQuestionByIndex(int index) async {
    try {
      await HiveService().deleteQuestion(index);
      questions.removeAt(index);
      AppConstFunctions.customSuccessMessage(message: 'Question deleted successfully!');
      update();
    } catch (e) {
      AppConstFunctions.customErrorMessage(message: 'Failed to delete question: $e');
    }
  }

  // ------------------------ Helpers ------------------------

  Question _buildQuestionFromInput() {
    return Question(
      questionText: questionController.text.trim(),
      options: optionControllers.map((c) => c.text.trim()).toList(),
      correctAnswer: selectedCorrectAnswer,
    );
  }
}
