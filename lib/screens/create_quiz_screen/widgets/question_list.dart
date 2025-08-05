import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/core/widgets/custom_pop_up_menu.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/question_controller.dart';
import 'package:teacher_panel/screens/create_quiz_screen/widgets/upsert_question_box.dart';

class QuestionList extends StatelessWidget {
  const QuestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      builder: (controller) {
        if (controller.isLoading) {
          return AppConstFunctions.customCircularProgressIndicator;
        } else if (controller.questions.isEmpty) {
          return CustomEmptyWidget(title: 'no_questions_available'.tr);
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemCount: controller.questions.length,
          separatorBuilder: (_, __) => Gap(12.h),
          itemBuilder: (context, index) {
            final q = controller.questions[index];
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryClr, width: 2.w),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${index + 1}. ${q.questionText}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      CustomPopUpMenu(
                        onUpdate: () => _showEditBottomSheet(context, index),
                        onDelete: () =>
                            controller.deleteQuestionByIndex(index),
                      )
                    ],
                  ),
                  Gap(8.h),
                  // Options
                  ...List.generate(2, (i) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            i == 0 ? 'ক। ${q.options[0]}' : 'খ। ${q.options[1]}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                              color: q.correctAnswer == i
                                  ? AppColors.greenClr
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            i == 0 ? 'গ। ${q.options[2]}' : 'ঘ। ${q.options[3]}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                              color: q.correctAnswer == i + 2
                                  ? AppColors.greenClr
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (_) => UpsertQuestionBox(
        isUpdate: true,
        questionIndex: index,
      ),
    );
  }
}
