import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/controllers/upsert_class_controller.dart';
import 'package:teacher_panel/screens/home_screen/models/class_model.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/utils/app_validators.dart';
import 'package:teacher_panel/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/widgets/custom_outlined_btn.dart';
import 'package:teacher_panel/widgets/custom_text_form_field.dart';

class UpsertClassBox extends StatefulWidget {
  final bool isUpdate;
  final ClassModel? classData;

  const UpsertClassBox({super.key, this.isUpdate = false, this.classData});

  @override
  State<UpsertClassBox> createState() => _UpsertClassBoxState();
}

class _UpsertClassBoxState extends State<UpsertClassBox> {
  final _upsertClassController = Get.find<UpsertClassController>();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.classData != null) {
     _assignData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
      ),
      child: Container(
        width: double.infinity.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: SingleChildScrollView(
          child: Form(
            key: _upsertClassController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isUpdate ? "Update Class" : "Create Class",
                    style: Theme.of(context).textTheme.titleMedium),
                Gap(20.h),
                CustomTextFormField(
                  controller: _upsertClassController.classNameController,
                  hintText: 'Class Name',
                  validator: AppValidators.requiredValidator,
                ),
                Gap(16.h),
                CustomTextFormField(
                  controller: _upsertClassController.numOfStudentsController,
                  hintText: 'Number of Students',
                  keyBoardType: TextInputType.number,
                  validator: AppValidators.requiredValidator,
                ),
                Gap(32.h),
                GetBuilder<UpsertClassController>(
                  builder: (controller) => controller.isLoading
                      ? AppConstFunctions.customCircularProgressIndicator
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Cancel Button
                            Expanded(
                              child: CustomOutlinedBtn(
                                onPressed: () => Get.back(),
                                name: 'CANCEL',
                              ),
                            ),
                            Gap(32.w),
                            Expanded(
                              child: CustomElevatedBtn(
                                onPressed: () {
                                  _formOnSubmit(controller, context);
                                },
                                name: widget.isUpdate ? 'UPDATE' : 'CREATE',
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _formOnSubmit(
      UpsertClassController controller, BuildContext context) async {
    if (controller.formKey.currentState!.validate()) {
      if (widget.isUpdate && widget.classData != null) {
        final result =
            await controller.updateClass(classId: widget.classData!.id!);
        if (result && context.mounted) {
          Navigator.of(context).pop();
        }
      } else {
        final result = await controller.createClass();
        if (result && context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  void _assignData() {
    _upsertClassController.classNameController.text =
        widget.classData!.className ?? '';
    _upsertClassController.numOfStudentsController.text =
        widget.classData!.numOfStudents ?? '';
  }
}
