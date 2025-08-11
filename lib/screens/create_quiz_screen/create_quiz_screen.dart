import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/data/services/hive_service.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/create_quiz_controller.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/question_controller.dart';
import 'package:teacher_panel/screens/create_quiz_screen/widgets/question_list.dart';
import 'package:teacher_panel/screens/create_quiz_screen/widgets/quiz_meta_form.dart';
import 'package:teacher_panel/screens/create_quiz_screen/widgets/upsert_question_box.dart';

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
        if (mounted) _showAlertDialogForDataLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
        title: 'create_mcq_questions'.tr,
        onPressed: () => Get.back(),
        actions: [_buildPublishButton(), Gap(12.w)],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: const [
            QuizMetaForm(),
            Expanded(child: QuestionList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('create'.tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white)),
        icon: const Icon(CupertinoIcons.add_circled_solid),
        onPressed: () => _showUpsertBottomSheet(),
      ),
    );
  }

  Widget _buildPublishButton() {
    return GetBuilder<QuestionController>(
      builder: (controller) {
        final isEnabled = controller.questions.length >= 5;
        return OutlinedButton(
          onPressed: isEnabled ? _showPublishDialog : null,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            minimumSize: Size(80.w, 40.h),
            side: BorderSide(
                color: isEnabled ? AppColors.primaryClr : Colors.grey,
                width: 3.w),
          ),
          child: Text('publish'.tr,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: isEnabled ? AppColors.primaryClr : Colors.grey)),
        );
      },
    );
  }

  void _showPublishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('confirm_publish'.tr),
        content: Text('confirm_publish_message'.tr),
        actions: [
          TextButton(onPressed: Get.back, child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () async {
              final result = await _createQuizController.createQuiz();
              if (result && mounted) {
                Get.close(2);
                HiveService().clearAllData();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('confirm'.tr, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUpsertBottomSheet({bool isUpdate = false, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
      builder: (_) => UpsertQuestionBox(
        isUpdate: isUpdate,
        questionIndex: index,
      ),
    );
  }

  void _showAlertDialogForDataLoad() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: Text('saved_quiz_found'.tr),
        content: Text('saved_quiz_found_message'.tr),
        actions: [
          TextButton(
            onPressed: () {
              HiveService().clearAllData();
              Get.back();
            },
            child: Text('discard'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              _questionController.getQuestionsFromLocalDb();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('load'.tr, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
