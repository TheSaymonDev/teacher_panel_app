import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/core/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/screens/subject_details_screen/widgets/quiz_list_section.dart';
import 'package:teacher_panel/screens/subject_details_screen/widgets/subject_header_section.dart';

class SubjectDetailsScreen extends StatelessWidget {
  const SubjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
        onPressed: () => Get.back(),
        title: 'subject_details'.tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16.h),
            SubjectHeaderSection(),
            Gap(16.h),
            CustomElevatedBtn(
                onPressed: () => Get.toNamed(AppRoutes.createQuizScreen),
                name: 'create_quiz'.tr),
            Gap(16.h),
            Text("quizzes".tr, style: Theme.of(context).textTheme.titleMedium),
            Gap(8.h),
            Expanded(child: QuizListSection())
          ],
        ),
      ),
    );
  }


}
