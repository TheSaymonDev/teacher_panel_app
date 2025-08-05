import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';

class ReportsCardSection extends StatelessWidget {
  const ReportsCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassDetailsController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () => Get.toNamed(
            AppRoutes.classReportAnalyticsScreen,
            arguments: {
              'className': controller.classData.className,
              'classId': controller.classId,
            },
          ),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('average_performance'.tr,
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text('${controller.avgPerformance.round()}%',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  Gap(16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('average_participants'.tr,
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text('${controller.avgParticipants.round()}%',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
