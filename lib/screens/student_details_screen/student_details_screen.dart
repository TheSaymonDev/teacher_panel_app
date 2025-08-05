import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/screens/student_details_screen/widgets/student_header_section.dart';
import 'package:teacher_panel/screens/student_details_screen/widgets/student_performance_section.dart';
import 'package:teacher_panel/screens/student_details_screen/widgets/student_subject_reports_section.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () => Get.back(), title: 'student_details'.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentHeaderSection(),
              Gap(20.h),
              Text(
                'performance_overview'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              StudentPerformanceSection(),
              Gap(20.h),
              Text(
                'subject_reports'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Gap(8.h),
              StudentSubjectReportsSection()
            ],
          ),
        ),
      ),
    );
  }
}
