import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class UpsertSubjectController extends GetxController {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final subjectNameController = TextEditingController();

  Future<bool> createSubject({required String classId}) async {
    _setLoading(true);
    final response = await FirebaseService().createSubject(
        classId: classId, subjectName: subjectNameController.text);
    _setLoading(false);
    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearAllFields();
      Get.find<ClassDetailsController>().refreshSubjects();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  Future<bool> updateSubject({
    required String classId,
    required String subjectId,
  }) async {
    _setLoading(true);
    final response = await FirebaseService().updateSubject(
      classId: classId,
      subjectId: subjectId,
      subjectName: subjectNameController.text,
    );
    _setLoading(false);
    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearAllFields();
      Get.find<ClassDetailsController>().refreshSubjects();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void _clearAllFields() {
    subjectNameController.clear();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
