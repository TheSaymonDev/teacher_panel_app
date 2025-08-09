import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/screens/profile_update_screen/controllers/upsert_profile_controller.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/utils/app_urls.dart';
import 'package:teacher_panel/core/utils/app_validators.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/core/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/core/widgets/custom_text_form_field.dart';

class ProfileUpdateScreen extends StatelessWidget {
  ProfileUpdateScreen({super.key});

  final _profileUpdateController = Get.find<UpsertProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () => Get.back(), title: 'profile_update'.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Form(
            key: _profileUpdateController.formKey,
            child: Column(
              children: [
                Gap(120.h),
                _buildProfileImageSection(),
                Gap(20.h),
                CustomTextFormField(
                  controller: _profileUpdateController.nameController,
                  validator: AppValidators.requiredValidator,
                  hintText: 'full_name'.tr,
                ),
                Gap(12.h),
                CustomTextFormField(
                  controller: _profileUpdateController.schoolNameController,
                  validator: AppValidators.requiredValidator,
                  hintText: 'school_name'.tr,
                ),
                Gap(20.h),
                GetBuilder<UpsertProfileController>(
                    builder: (controller) => controller.isLoading
                        ? AppConstFunctions.customCircularProgressIndicator
                        : CustomElevatedBtn(
                            onPressed: () => _formOnSubmit(controller),
                            name: 'done'.tr,
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GetBuilder<UpsertProfileController> _buildProfileImageSection() {
    return GetBuilder<UpsertProfileController>(
      builder: (controller) {
        Widget buildProfileImage() {
          final selectedImage = controller.selectedImage;
          final imageUrl = controller.teacherData.imageUrl;

          return selectedImage != null
              ? Image.file(selectedImage, fit: BoxFit.cover)
              : (imageUrl?.isNotEmpty ?? false)
                  ? Image.memory(base64Decode(imageUrl!), fit: BoxFit.cover)
                  : Image.asset(AppUrls.demoProfile, fit: BoxFit.cover);
        }

        return Center(
          child: GestureDetector(
            onTap: controller.pickImage,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 130.h,
                  width: 140.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.grey.shade200,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: buildProfileImage(),
                ),
                Container(
                  height: 130.h,
                  width: 140.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _formOnSubmit(UpsertProfileController controller) async {
    if (controller.formKey.currentState!.validate()) {
      final result = await controller.saveTeacherProfileInfo();
      if (result) {
        Get.offAllNamed(AppRoutes.homeScreen);
      }
    }
  }
}
