import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/core/widgets/custom_expansion_tile.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_details_controller.dart';
import 'package:teacher_panel/screens/subject_details_screen/models/quiz_model.dart';
import 'package:teacher_panel/screens/subject_details_screen/widgets/option_tile.dart';

class QuizListSection extends StatelessWidget {
  QuizListSection({super.key});

  final _controller = Get.find<SubjectDetailsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubjectDetailsController>(
      builder: (controller) => controller.isLoading
          ? AppConstFunctions.customCircularProgressIndicator
          : controller.quizzes.isEmpty
              ? CustomEmptyWidget(title: 'no_quiz_added'.tr)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.quizzes.length,
                  itemBuilder: (context, index) {
                    final quizItem = controller.quizzes[index];
                    return CustomExpansionTile(
                        title: quizItem.topicName ?? '',
                        subTitle:
                            '${'date_label'.tr}: ${AppConstFunctions.formatCreatedAt(quizItem.createdAt!)}',
                        trailing: IconButton(
                            onPressed: () => _showQuizDeleteConfirmationDialog(
                                  context,
                                  _controller.classId,
                                  _controller.subjectId,
                                  quizItem.id!,
                                ),
                            icon: Icon(Icons.delete,
                                color: AppColors.secondaryClr, size: 20.sp)),
                        expandedContent:
                            _buildExpandedQuestions(quizItem, context));
                  },
                  separatorBuilder: (context, index) => Gap(8.h),
                ),
    );
  }

  Column _buildExpandedQuestions(QuizModel quizItem, BuildContext context) {
    return Column(
        spacing: 16.h,
        children: List.generate(quizItem.questions!.length, (index) {
          final question = quizItem.questions![index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${index + 1}. ${question.questionText}',
                  style: Theme.of(context).textTheme.bodyMedium),
              Gap(8.h),
              Row(
                children: [
                  OptionTile(
                    label: 'ক',
                    text: question.options![0],
                    index: 0,
                    correctAnswer: question.correctAnswer!,
                  ),
                  OptionTile(
                    label: 'খ',
                    text: question.options![1],
                    index: 1,
                    correctAnswer: question.correctAnswer!,
                  ),
                ],
              ),
              Gap(4.h),
              Row(
                children: [
                  OptionTile(
                    label: 'গ',
                    text: question.options![2],
                    index: 2,
                    correctAnswer: question.correctAnswer!,
                  ),
                  OptionTile(
                    label: 'ঘ',
                    text: question.options![3],
                    index: 3,
                    correctAnswer: question.correctAnswer!,
                  ),
                ],
              ),
            ],
          );
        }));
  }

  void _showQuizDeleteConfirmationDialog(
      BuildContext context, String classId, String subjectId, String quizId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm_delete'.tr,
            style: Theme.of(context).textTheme.titleMedium),
        content: Text('delete_quiz_confirmation'.tr,
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () async {
              final result = await _controller.deleteQuizById(
                  classId: classId, subjectId: subjectId, quizId: quizId);
              if (result && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('delete'.tr, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
