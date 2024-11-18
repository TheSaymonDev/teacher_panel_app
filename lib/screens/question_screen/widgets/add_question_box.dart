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

class AddQuestionBox extends StatelessWidget {
  AddQuestionBox({super.key});

  final _addQuestionController = Get.find<QuestionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
      child: SingleChildScrollView(
        child: Form(
          key: _addQuestionController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Question",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Gap(20.h),
              CustomTextFormField(
                controller: _addQuestionController.questionController,
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
                    controller: _addQuestionController.optionControllers[index],
                    hintText: 'Option ${index + 1}',
                    validator: AppValidators.requiredValidator,
                  ),
                ),
              ),
              Gap(16.h),
              Container(
                height: 80.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: primaryClr, width: 2.w),
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
                                    name: 'SAVE'))
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
      await controller.addQuestionToLocalDb();
    }
  }
}
