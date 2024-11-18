import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/question_screen/controllers/question_controller.dart';
import 'package:teacher_panel/screens/question_screen/widgets/add_question_box.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/widgets/custom_app_bar.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            Get.back();
          },
          title: 'QUESTIONS'),
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GetBuilder<QuestionController>(
          builder: (controller) {
            if (controller.isLoading) {
              return Center(
                  child: AppConstFunctions.customCircularProgressIndicator);
            }
            if (controller.questions.isEmpty) {
              return const Center(child: Text('No questions available'));
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              separatorBuilder: (context, index) => Gap(12.h),
              itemCount: controller.questions.length,
              itemBuilder: (context, index) {
                final question = controller.questions[index];
                return Container(
                  width: double.infinity.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryClr, width: 2.w),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${index + 1}. Question',
                                style: Theme.of(context).textTheme.bodyMedium),
                            FittedBox(
                              child: PopupMenuButton<int>(
                                borderRadius: BorderRadius.circular(12.r),
                                color: Colors.white,
                                iconSize: 60.sp,
                                icon: Icon(Icons.more_vert, color: Colors.grey),
                                menuPadding: EdgeInsets.zero,
                                onSelected: (value) {
                                  if (value == 1) {
                                  } else if (value == 2) {}
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    height: 40.h,
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit,
                                            color: primaryClr, size: 20.sp),
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
                                            color: secondaryClr, size: 20.sp),
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
                          style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        children: [
                          Expanded(
                              child: Text('ক। ${question.options[0]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: question.correctAnswer == 0
                                              ? greenClr
                                              : null))),
                          Expanded(
                              child: Text('খ। ${question.options[1]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: question.correctAnswer == 1
                                              ? greenClr
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
                                          color: question.correctAnswer == 2
                                              ? greenClr
                                              : null))),
                          Expanded(
                              child: Text('ঘ। ${question.options[3]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: question.correctAnswer == 3
                                              ? greenClr
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            builder: (context) => AddQuestionBox(),
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
}
