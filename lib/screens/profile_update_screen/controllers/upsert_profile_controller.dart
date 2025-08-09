import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teacher_panel/data/models/teacher_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class UpsertProfileController extends GetxController {
  final nameController = TextEditingController();
  final schoolNameController = TextEditingController();
  File? selectedImage;
  bool isLoading = false;
  bool isEditMode = false;
  final formKey = GlobalKey<FormState>();
  late TeacherModel teacherData;

  @override
  void onInit() {
    super.onInit();
    teacherData = Get.arguments['teacherInfo'] as TeacherModel;
    nameController.text = teacherData.fullName ?? '';
    schoolNameController.text = teacherData.schoolName ?? '';
    if (teacherData.id != null) {
      isEditMode = true;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
      update();
    }
  }

  Future<bool> saveTeacherProfileInfo() async {
    _setLoading(true);

    final firebaseService = FirebaseService();
    final response = isEditMode
        ? await firebaseService.updateTeacherInfo(
            docId: teacherData.id!,
            fullName: nameController.text,
            schoolName: schoolNameController.text,
            profileImage: selectedImage,
          )
        : await firebaseService.createTeacherInfo(
            fullName: nameController.text,
            schoolName: schoolNameController.text,
            profileImage: selectedImage,
          );

    _setLoading(false);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(
        message: isEditMode
            ? 'Profile successfully updated'
            : 'Profile successfully created',
      );
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
    nameController.dispose();
    schoolNameController.dispose();
    super.onClose();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
