import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/add_class_screen/controllers/add_class_controller.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/widgets/custom_outlined_btn.dart';
import 'package:teacher_panel/widgets/custom_text_form_field.dart';

class AddClassScreen extends StatelessWidget {
  AddClassScreen({super.key});

  final _addClassController = Get.find<AddClassController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () {
            Get.back();
          },
          title: 'Add Your Class'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(32.h),
              CustomTextFormField(
                controller: _addClassController.classNameController,
                hintText: 'Class Name',
              ),
              Gap(16.h),
              CustomTextFormField(
                  controller: _addClassController.classCodeController,
                  hintText: 'Class Code (Optional)'),
              Gap(16.h),
              CustomTextFormField(
                  controller: _addClassController.numberOfStudentController,
                  hintText: 'Number of Students'),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                        controller: _addClassController.subjectController,
                        hintText: 'Subject Name'),
                  ),
                  Gap(4.w),
                  IconButton.outlined(
                    onPressed: () => _addClassController.addSubject(),
                    icon: Icon(Icons.add, color: AppColors.primaryClr),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryClr, width: 2.w),
                    ),
                  )
                ],
              ),
              Gap(8.h),
              _buildSubjects(context),
              Gap(32.h),
              CustomElevatedBtn(onPressed: () {}, name: 'Save Class'),
              Gap(16.h),
              CustomOutlinedBtn(onPressed: () {}, name: 'Cancel'),
              Gap(32.h),
            ],
          ),
        ),
      ),
    );
  }

  GetBuilder<AddClassController> _buildSubjects(BuildContext context) {
    return GetBuilder<AddClassController>(
                builder: (controller) => controller.subjects.isNotEmpty
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          children: List.generate(
                            controller.subjects.length,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(controller.subjects[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove_circle,
                                        color: AppColors.secondaryClr),
                                    onPressed: () =>
                                        controller.removeSubject(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox());
  }
}
