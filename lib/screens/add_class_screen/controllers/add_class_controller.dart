import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class AddClassController extends GetxController {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();
  final classCodeController = TextEditingController();
  final numberOfStudentController = TextEditingController();
  final subjectController = TextEditingController();

  final subjects = <String>[];
  void addSubject() {
    if (subjectController.text.trim().isNotEmpty) {
      subjects.add(subjectController.text);
      subjectController.clear();
      update();
    }
  }

  void removeSubject(int index) {
    subjects.removeAt(index);
    update();
  }

  Future<bool> createClassToFirebase() async {
    _setLoading(true);
    if (subjects.isEmpty) {
      AppConstFunctions.customErrorMessage(
          message: 'Minimum a subject is required to create.');
      _setLoading(false);
      return false;
    }

    final response = await FirebaseService().createClass(
        className: classNameController.text,
        classCode: classCodeController.text,
        numOfStudents: numberOfStudentController.text,
        subjects: subjects);

    _setLoading(false);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(
          message: 'Successfully Class Created');
      _clearAllFields();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void _clearAllFields() {
    classNameController.clear();
    classCodeController.clear();
    numberOfStudentController.clear();
    subjects.clear();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
