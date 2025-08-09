import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/controllers/manage_class_controller.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class UpsertClassController extends GetxController {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();
  final numOfStudentsController = TextEditingController();
  final sectionController = TextEditingController();

  final _firebaseService = FirebaseService();

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void _clearFields() {
    classNameController.clear();
    numOfStudentsController.clear();
    sectionController.clear();
  }

  Future<bool> createClass() async {
    _setLoading(true);
    final response = await _firebaseService.createClass(
      className: classNameController.text,
      section: sectionController.text,
      numOfStudents: numOfStudentsController.text,
    );
    _setLoading(false);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearFields();
      Get.find<ManageClassController>().refreshClass();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  Future<bool> updateClass({required String classId}) async {
    _setLoading(true);
    final response = await _firebaseService.updateClass(
      classId: classId,
      className: classNameController.text,
      numOfStudents: numOfStudentsController.text,
    );
    _setLoading(false);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearFields();
      Get.find<ManageClassController>().refreshClass();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  @override
  void onClose() {
    classNameController.dispose();
    numOfStudentsController.dispose();
    sectionController.dispose();
    super.onClose();
  }
}
