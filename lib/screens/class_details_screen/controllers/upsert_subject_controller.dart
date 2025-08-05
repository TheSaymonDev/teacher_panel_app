import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';

class UpsertSubjectController extends GetxController {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final subjectNameController = TextEditingController();

  final _firebaseService = FirebaseService();

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void _clearFields() {
    subjectNameController.clear();
  }

  Future<bool> createSubject({required String classId}) async {
    _setLoading(true);
    final response = await _firebaseService.createSubject(
      classId: classId,
      subjectName: subjectNameController.text,
    );
    _setLoading(false);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearFields();
      Get.find<ClassDetailsController>().refreshSubjects();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Something went wrong',
      );
      return false;
    }
  }

  Future<bool> updateSubject({
    required String classId,
    required String subjectId,
  }) async {
    _setLoading(true);
    final response = await _firebaseService.updateSubject(
      classId: classId,
      subjectId: subjectId,
      subjectName: subjectNameController.text,
    );
    _setLoading(false);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearFields();
      Get.find<ClassDetailsController>().refreshSubjects();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Something went wrong',
      );
      return false;
    }
  }

  @override
  void onClose() {
    subjectNameController.dispose();
    super.onClose();
  }
}
