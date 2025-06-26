import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_details_controller.dart';
import 'package:teacher_panel/screens/subject_details_screen/models/quiz_model.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/widgets/custom_expansion_tile.dart';
import 'package:teacher_panel/widgets/custom_gradient_container.dart';

class SubjectDetailsScreen extends StatelessWidget {
  SubjectDetailsScreen({super.key});

  final _subjectDetailsController = Get.find<SubjectDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
        onPressed: () => Get.back(),
        title: 'Subject Details',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(16.h),
              _buildHeader(context),
              Gap(16.h),
              CustomElevatedBtn(
                  onPressed: () => Get.toNamed(AppRoutes.createQuizScreen),
                  name: 'Create Quiz'),
              Gap(16.h),
              Text("Quizzes", style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              _buildQuizList(context),
            ],
          ),
        ),
      ),
    );
  }

  CustomGradientContainer _buildHeader(BuildContext context) {
    return CustomGradientContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _subjectDetailsController.subjectData.subjectName ?? '',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          Divider(color: Colors.white, thickness: 1.0),
          Gap(8.h),
          Row(
            children: [
              Icon(Icons.class_, size: 20.sp, color: Colors.white),
              Gap(8.w),
              Text(
                "Class: ${_subjectDetailsController.classData.className}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
          Gap(8.h),
          GetBuilder<SubjectDetailsController>(
            builder: (controller) => Row(
              children: [
                Icon(Icons.quiz, size: 20.sp, color: Colors.white),
                Gap(8.w),
                Text(
                  "Total Quizzes: ${controller.quizzes.length}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizList(BuildContext context) {
    return GetBuilder<SubjectDetailsController>(
      builder: (controller) => controller.isLoading
          ? AppConstFunctions.customCircularProgressIndicator
          : controller.quizzes.isEmpty
              ? CustomEmptyWidget(title: 'No quiz added!')
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.quizzes.length,
                  itemBuilder: (context, index) {
                    final quizItem = controller.quizzes[index];
                    return CustomExpansionTile(
                        title: quizItem.topicName ?? '',
                        subTitle:
                            'Date: ${AppConstFunctions.formatCreatedAt(quizItem.createdAt!)}',
                        trailing: IconButton(
                            onPressed: () => _showQuizDeleteConfirmationDialog(
                                  context,
                                  _subjectDetailsController.classId,
                                  _subjectDetailsController.subjectId,
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
                  Expanded(
                      child: Text('ক। ${question.options![0]}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: question.correctAnswer == 0
                                      ? AppColors.greenClr
                                      : null))),
                  Expanded(
                      child: Text('খ। ${question.options![1]}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: question.correctAnswer == 1
                                      ? AppColors.greenClr
                                      : null))),
                ],
              ),
              Gap(4.h),
              Row(
                children: [
                  Expanded(
                      child: Text('গ। ${question.options![2]}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: question.correctAnswer == 2
                                      ? AppColors.greenClr
                                      : null))),
                  Expanded(
                      child: Text('ঘ। ${question.options![3]}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: question.correctAnswer == 3
                                      ? AppColors.greenClr
                                      : null))),
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
        title: Text('Confirm Delete',
            style: Theme.of(context).textTheme.titleMedium),
        content: Text('Are you sure you want to delete this quiz?',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await _subjectDetailsController.deleteQuizById(
                  classId: classId, subjectId: subjectId, quizId: quizId);
              if (result && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryClr),
            child: Text('Delete',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
