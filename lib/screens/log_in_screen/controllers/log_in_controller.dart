import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/log_in_screen/models/log_in_model.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/services/shared_preference_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class LogInController extends GetxController {
  bool isLoading = false;
  bool isObscure = true;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> logInUser({required LogInModel logInData}) async {
    _setLoading(true);
    try {
      final user = await FirebaseService().signIn(
        logInData.email!,
        logInData.password!,
      );
      _setLoading(false);

      if (user != null) {
        AppConstFunctions.customSuccessMessage(message: 'Successfully Logged In');
        SharedPreferencesService().saveUserId(user.uid);
        return true;
      } else {
        AppConstFunctions.customErrorMessage(message: 'Invalid email or password');
        return false;
      }
    } catch (error) {
      _setLoading(false);
      AppConstFunctions.customErrorMessage(message: error.toString());
      return false;
    }
  }

  void toggleObscure() {
    isObscure = !isObscure;
    update();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
