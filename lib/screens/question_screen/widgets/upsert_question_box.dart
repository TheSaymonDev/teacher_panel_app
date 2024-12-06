import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/question_screen/controllers/question_controller.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/utils/app_validators.dart';
import 'package:teacher_panel/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/widgets/custom_outlined_btn.dart';
import 'package:teacher_panel/widgets/custom_text_form_field.dart';

class UpsertQuestionBox extends StatelessWidget {
  final bool isUpdate;
  final int? questionIndex;

  UpsertQuestionBox({super.key, this.isUpdate = false, this.questionIndex});

  final _upsertQuestionController = Get.find<QuestionController>();

  @override
  Widget build(BuildContext context) {
    if (isUpdate && questionIndex != null) {
      final question = _upsertQuestionController.questions[questionIndex!];
      _upsertQuestionController.questionController.text = question.questionText;
      for (int i = 0; i < 4; i++) {
        _upsertQuestionController.optionControllers[i].text = question.options[i];
      }
      _upsertQuestionController.selectedCorrectAns = question.correctAnswer;
    }
    return Container(
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
      child: SingleChildScrollView(
        child: Form(
          key: _upsertQuestionController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUpdate ? "Update Question" : "Add Question",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Gap(20.h),
              CustomTextFormField(
                controller: _upsertQuestionController.questionController,
                hintText: 'Question',
                maxLines: 3,
                validator: AppValidators.requiredValidator,
              ),
              Gap(16.h),
              Column(
                spacing: 8.h,
                children: List.generate(
                  4,
                  (index) => CustomTextFormField(
                    controller: _upsertQuestionController.optionControllers[index],
                    hintText: 'Option ${index + 1}',
                    validator: AppValidators.requiredValidator,
                  ),
                ),
              ),
              Gap(16.h),
              // Correct answer choosing part (same as before)
              Container(
                height: 80.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primaryClr, width: 2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(12.h),
                    Text(
                      'Choose Correct Answer',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Expanded(
                      child: FittedBox(
                        child: GetBuilder<QuestionController>(
                            builder: (controller) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              4,
                              (index) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio(
                                    value: index,
                                    groupValue: controller.selectedCorrectAns,
                                    onChanged: (value) =>
                                        controller.updateCorrectAns(value!),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text(
                                    'Option ${index + 1}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(32.h),
              GetBuilder<QuestionController>(
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
                                      _formOnSubmit(controller);
                                    },
                                    name: isUpdate ? 'UPDATE' : 'SAVE'))
                          ],
                        )),
            ],
          ),
        ),
      ),
    );
  }

  void _formOnSubmit(QuestionController controller) async {
    if (controller.formKey.currentState!.validate()) {
      if (isUpdate && questionIndex != null) {
        await controller.updateQuestionByIndex(questionIndex!);
      } else {
        await controller.addQuestionToLocalDb();
      }
    }
  }
}
