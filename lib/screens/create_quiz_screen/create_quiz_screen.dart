import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/create_quiz_controller.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/question_controller.dart';
import 'package:teacher_panel/screens/create_quiz_screen/widgets/upsert_question_box.dart';
import 'package:teacher_panel/services/hive_service.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/utils/app_validators.dart';
import 'package:teacher_panel/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/widgets/custom_pop_up_menu.dart';
import 'package:teacher_panel/widgets/custom_text_form_field.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _createQuizController = Get.find<CreateQuizController>();
  final _questionController = Get.find<QuestionController>();

  @override
  void initState() {
    super.initState();
    final hasData = HiveService().getQuestions();
    if (hasData.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          _showAlertDialogForDataLoad(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
        onPressed: () => Get.back(),
        title: 'QUESTIONS',
        actions: [_buildPublishBtn(context), Gap(12.w)],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(16.h),
              _buildTopicHeader(context),
              _buildQuestionList(context),
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
        label: Text('Create',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white)),
        icon: Icon(CupertinoIcons.add_circled_solid),
        foregroundColor: Colors.white,
      ),
    );
  }

  GetBuilder<QuestionController> _buildPublishBtn(BuildContext context) {
    return GetBuilder<QuestionController>(
      builder: (controller) {
        final isPublishable = controller.questions.length >= 5;
        return SizedBox(
          height: 36.h,
          child: OutlinedButton(
            onPressed: isPublishable
                ? () {
                    _showAlertDialogForPublish(context);
                  }
                : null,
            style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: isPublishable
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    width: 1.5.w)),
            child: Text(
              'Publish',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: isPublishable ? AppColors.primaryClr : Colors.grey),
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialogForPublish(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Confirm Publish',
                  style: Theme.of(context).textTheme.titleMedium),
              content: Text('Are you sure you want to publish this quiz?',
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel',
                        style: Theme.of(context).textTheme.bodyMedium)),
                ElevatedButton(
                    onPressed: () async {
                      final result = await _createQuizController.createQuiz();
                      if (result && context.mounted) {
                        HiveService().clearAllData();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryClr),
                    child: Text('Confirm',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white))),
              ],
            ));
  }

  Widget _buildQuestionList(BuildContext context) {
    return GetBuilder<QuestionController>(
        builder: (controller) => controller.isLoading
            ? AppConstFunctions.customCircularProgressIndicator
            : controller.questions.isEmpty
                ? CustomEmptyWidget(title: 'No Questions Available!')
                : ListView.separated(
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
                          border: Border.all(
                              color: AppColors.primaryClr, width: 2.w),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.h,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                      '${index + 1}. ${question.questionText}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                                CustomPopUpMenu(onUpdate: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(12.r))),
                                      builder: (context) => UpsertQuestionBox(
                                          isUpdate: true,
                                          questionIndex: index));
                                }, onDelete: () {
                                  controller.deleteQuestionByIndex(index);
                                }),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('ক। ${question.options[0]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color:
                                                    question.correctAnswer == 0
                                                        ? AppColors.greenClr
                                                        : null))),
                                Expanded(
                                    child: Text('খ। ${question.options[1]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color:
                                                    question.correctAnswer == 1
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
                                            .bodySmall!
                                            .copyWith(
                                                color:
                                                    question.correctAnswer == 2
                                                        ? AppColors.greenClr
                                                        : null))),
                                Expanded(
                                    child: Text('ঘ। ${question.options[3]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color:
                                                    question.correctAnswer == 3
                                                        ? AppColors.greenClr
                                                        : null))),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ));
  }

  Widget _buildTopicHeader(BuildContext context) {
    return Form(
      key: _createQuizController.formKey,
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: CustomTextFormField(
                controller: _createQuizController.topicNameController,
                hintText: 'Topic Name',
                validator: AppValidators.requiredValidator,
              ),
            ),
            Gap(16.h),
            GetBuilder<CreateQuizController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Time: ${controller.selectedDuration} minutes",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Slider(
                      value: controller.selectedDuration.toDouble(),
                      min: 1,
                      max: 60,
                      divisions: 59,
                      inactiveColor:
                          context.isDarkMode ? Colors.white38 : Colors.black12,
                      label: "${controller.selectedDuration} minutes",
                      onChanged: (value) {
                        controller.updateDuration(value.toInt());
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialogForDataLoad(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Saved Quiz Found!',
                  style: Theme.of(context).textTheme.titleMedium),
              content: Text('You have saved data. Do you want to load it?',
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    HiveService().clearAllData();
                  },
                  child: Text(
                    'Discard',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _questionController.getQuestionsFromLocalDb();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryClr),
                  child: Text('Load',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ));
  }
}
