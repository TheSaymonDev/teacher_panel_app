import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/screens/class_details_screen/widgets/class_header_section.dart';
import 'package:teacher_panel/screens/class_details_screen/widgets/leaderboard_card_section.dart';
import 'package:teacher_panel/screens/class_details_screen/widgets/reports_card_section.dart';
import 'package:teacher_panel/screens/class_details_screen/widgets/student_list_section.dart';
import 'package:teacher_panel/screens/class_details_screen/widgets/subject_list_section.dart';
import 'package:teacher_panel/screens/class_details_screen/widgets/upsert_subject_box.dart';

class ClassDetailsScreen extends StatelessWidget {
  const ClassDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
        title: 'class_details'.tr,
        onPressed: () => Get.back(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(16.h),
              ClassHeaderSection(),
              Gap(20.h),
              Text('subjects'.tr, style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              SubjectListSection(),
              Gap(20.h),
              Text('reports_analytics'.tr, style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              ReportsCardSection(),
              Gap(20.h),
              LeaderboardCardSection(),
              Gap(20.h),
              Text('students'.tr, style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              StudentListSection(),
              Gap(32.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUpsertSubjectBox(context),
        icon: Icon(Icons.add_circle, color: Colors.white),
        label: Text("create".tr, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
      ),
    );
  }

  void _showUpsertSubjectBox(BuildContext context, [dynamic subject]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
      builder: (_) => UpsertSubjectBox(
        isUpdate: subject != null,
        subjectData: subject,
      ),
    );
  }
}
