import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/controllers/manage_class_controller.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class UpsertClassController extends GetxController {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();
  final numOfStudentsController = TextEditingController();

  Future<bool> createClass() async {
    _setLoading(true);
    final response = await FirebaseService().createClass(
      className: classNameController.text,
      numOfStudents: numOfStudentsController.text,
    );
    _setLoading(false);
    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearAllFields();
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
    final response = await FirebaseService().updateClass(
      classId: classId,
      className: classNameController.text,
      numOfStudents: numOfStudentsController.text,
    );
    _setLoading(false);
    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _clearAllFields();
      Get.find<ManageClassController>().refreshClass();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void _clearAllFields() {
    classNameController.clear();
    numOfStudentsController.clear();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
