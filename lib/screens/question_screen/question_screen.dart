import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/question_screen/controllers/firebase_question_controller.dart';
import 'package:teacher_panel/screens/question_screen/controllers/question_controller.dart';
import 'package:teacher_panel/screens/question_screen/widgets/upsert_question_box.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/utils/app_validators.dart';
import 'package:teacher_panel/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/widgets/custom_text_form_field.dart';

class QuestionScreen extends StatelessWidget {
  QuestionScreen({super.key});

  final _firebaseQuestionController = Get.find<FirebaseQuestionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () {
            Get.back();
          },
          title: 'QUESTIONS'),
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(16.h),
              Container(
                width: double.infinity.w,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryClr, width: 2.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Form(
                  key: _firebaseQuestionController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomTextFormField(
                          controller: _firebaseQuestionController.topicNameController,
                          hintText: 'Topic Name',
                          validator: AppValidators.requiredValidator,
                        ),
                      ),
                      Gap(16.h),
                      GetBuilder<FirebaseQuestionController>(
                        builder: (controller) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  "Time: ${controller.selectedDuration} minutes",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Slider(
                                value: controller.selectedDuration.toDouble(),
                                min: 1,
                                max: 60,
                                divisions: 59,
                                label: "${controller.selectedDuration} minutes",
                                onChanged: (value) {
                                  controller.updateDuration(value.toInt());
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GetBuilder<FirebaseQuestionController>(
                            builder: (controller) => controller.isLoading
                                ? AppConstFunctions
                                    .customCircularProgressIndicator
                                : CustomElevatedBtn(
                                    onPressed: () {
                                      _formOnSubmit(controller);
                                    }, name: 'PUBLISH')),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                child: GetBuilder<QuestionController>(
                  builder: (controller) {
                    if (controller.isLoading) {
                      return Center(
                          child: AppConstFunctions
                              .customCircularProgressIndicator);
                    }
                    if (controller.questions.isEmpty) {
                      return Center(
                          child: Text('No questions available',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: AppColors.secondaryClr)));
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      separatorBuilder: (context, index) => Gap(12.h),
                      itemCount: controller.questions.length,
                      itemBuilder: (context, index) {
                        final question = controller.questions[index];
                        return Container(
                          width: double.infinity.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryClr, width: 2.w),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.h,
                            children: [
                              SizedBox(
                                height: 30.h,
                                width: double.infinity.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${index + 1}. Question',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    FittedBox(
                                      child: PopupMenuButton<int>(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        color: Colors.white,
                                        iconSize: 60.sp,
                                        icon: Icon(Icons.more_vert,
                                            color: Colors.grey),
                                        menuPadding: EdgeInsets.zero,
                                        onSelected: (value) {
                                          if (value == 1) {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            12.r)),
                                              ),
                                              builder: (context) =>
                                                  UpsertQuestionBox(
                                                isUpdate: true,
                                                questionIndex: index,
                                              ),
                                            );
                                          } else if (value == 2) {
                                            controller
                                                .deleteQuestionByIndex(index);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            height: 40.h,
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: AppColors.primaryClr,
                                                    size: 20.sp),
                                                Gap(6.w),
                                                Text('Update',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            height: 40.h,
                                            value: 2,
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: AppColors.secondaryClr,
                                                    size: 20.sp),
                                                Gap(6.w),
                                                Text('Delete',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(question.questionText,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text('ক। ${question.options[0]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color:
                                                      question.correctAnswer ==
                                                              0
                                                          ? AppColors.greenClr
                                                          : null))),
                                  Expanded(
                                      child: Text('খ। ${question.options[1]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color:
                                                      question.correctAnswer ==
                                                              1
                                                          ? AppColors.greenClr
                                                          : null))),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text('গ। ${question.options[2]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color:
                                                      question.correctAnswer ==
                                                              2
                                                          ? AppColors.greenClr
                                                          : null))),
                                  Expanded(
                                      child: Text('ঘ। ${question.options[3]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color:
                                                      question.correctAnswer ==
                                                              3
                                                          ? AppColors.greenClr
                                                          : null))),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            builder: (context) => UpsertQuestionBox(),
          );
        },
        label: Text('ADD',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white)),
        icon: Icon(CupertinoIcons.add_circled_solid),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _formOnSubmit(FirebaseQuestionController controller) async{
    if(controller.formKey.currentState!.validate()){
      final result = await controller.publishQuestionToFirebase();
      if(result){
        Get.back();
      }
    }
  }
}
