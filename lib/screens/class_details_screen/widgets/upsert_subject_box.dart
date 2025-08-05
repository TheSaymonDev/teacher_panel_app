import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/utils/app_validators.dart';
import 'package:teacher_panel/core/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/core/widgets/custom_outlined_btn.dart';
import 'package:teacher_panel/core/widgets/custom_text_form_field.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/upsert_subject_controller.dart';
import 'package:teacher_panel/data/models/subject_model.dart';


class UpsertSubjectBox extends StatefulWidget {
  final bool isUpdate;
  final String classId;
  final SubjectModel? subjectData;

  const UpsertSubjectBox(
      {super.key,
      this.isUpdate = false,
      required this.classId,
      this.subjectData});

  @override
  State<UpsertSubjectBox> createState() => _UpsertSubjectBoxState();
}

class _UpsertSubjectBoxState extends State<UpsertSubjectBox> {
  final _upsertSubjectController = Get.find<UpsertSubjectController>();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.subjectData != null) {
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
            key: _upsertSubjectController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isUpdate ? "Update Subject" : "Create Subject",
                    style: Theme.of(context).textTheme.titleMedium),
                Gap(20.h),
                CustomTextFormField(
                    controller: _upsertSubjectController.subjectNameController,
                    hintText: 'Subject Name',
                    validator: AppValidators.requiredValidator),
                Gap(32.h),
                GetBuilder<UpsertSubjectController>(
                    builder: (controller) => controller.isLoading
                        ? AppConstFunctions.customCircularProgressIndicator
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomOutlinedBtn(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    name: 'CANCEL'),
                              ),
                              Gap(32.w),
                              Expanded(
                                  child: CustomElevatedBtn(
                                      onPressed: () {
                                        _formOnSubmit(controller, context);
                                      },
                                      name:
                                          widget.isUpdate ? 'UPDATE' : 'CREATE'))
                            ],
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _formOnSubmit(
      UpsertSubjectController controller, BuildContext context) async {
    if (controller.formKey.currentState!.validate()) {
      if (widget.isUpdate && widget.subjectData != null) {
        final result = await controller.updateSubject(
            classId: widget.classId, subjectId: widget.subjectData!.id!);
        if (result && context.mounted) {
          Navigator.of(context).pop();
        }
      } else {
        final result = await controller.createSubject(classId: widget.classId);
        if (result && context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  void _assignData() {
    _upsertSubjectController.subjectNameController.text =
        widget.subjectData!.subjectName ?? '';
  }
}
