import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/student_details_screen/controllers/student_performance_controller.dart';

class StudentPerformanceSection extends StatelessWidget {
  const StudentPerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentPerformanceController>(
      builder: (controller) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'average_score'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${controller.averageScore.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Gap(12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total_quizzes_attempted'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${controller.totalQuizAttempted}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Gap(12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'best_performing_subject'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      controller.bestPerformingSubject,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
