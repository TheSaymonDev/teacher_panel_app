import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/class_reports_analytics_screen/controllers/class_reports_analytics_controller.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';

class ClassReportsAnalyticsScreen extends StatelessWidget {
  ClassReportsAnalyticsScreen({super.key});

  final _controller = Get.find<ClassReportsAnalyticsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () => Get.back(),
          title: 'Class ${_controller.className} ${'reports_analytics_title'.tr}'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16.h),
            // Overall Performance Section
            Text(
              'overall_performance'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _buildOverallPerformance(context),
            Gap(20.h),
            // Subject-wise Performance Section
            Text(
              'subject_wise_performance'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _buildSubjectPerformance(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallPerformance(BuildContext context) {
    return GetBuilder<ClassReportsAnalyticsController>(builder: (controller) {
      return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              _buildPerformanceRow(
                icon: Icons.bar_chart,
                label: 'average_performance'.tr,
                value: '${controller.avgPerformance.round()}%',
                context: context,
              ),
              Gap(12.h),
              _buildPerformanceRow(
                icon: Icons.groups,
                label: 'average_participants'.tr,
                value: '${controller.avgParticipants.round()}%',
                context: context,
              ),
              Gap(12.h),
              _buildPerformanceRow(
                icon: Icons.quiz,
                label: 'total_quizzes'.tr,
                value: '${controller.totalQuizzes}',
                context: context,
              ),
              Gap(12.h),
              _buildPerformanceRow(
                icon: Icons.check_circle,
                label: 'total_quizzes_taken'.tr,
                value: '${controller.totalQuizzesTaken}',
                context: context,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPerformanceRow({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20.sp),
            Gap(10.w),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildSubjectPerformance(BuildContext context) {
    return Expanded(
      child: GetBuilder<ClassReportsAnalyticsController>(
        builder: (controller) => controller.isLoading
            ? AppConstFunctions.customCircularProgressIndicator
            : controller.subjectWisedData.isEmpty
                ? CustomEmptyWidget(title: 'no_subject_wise_performance'.tr)
                : ListView.separated(
                    itemCount: controller.subjectWisedData.length,
                    separatorBuilder: (context, index) => Gap(0.h),
                    itemBuilder: (context, index) {
                      final subject = controller.subjectWisedData[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          child: Row(
                            children: [
                              CircularPercentIndicator(
                                radius: 45.0.r,
                                lineWidth: 10.0.w,
                                animation: true,
                                animationDuration: 1500,
                                percent: subject.avgPerformance! / 100,
                                center: Text(
                                  "${subject.avgPerformance!.toInt()}%",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.green,
                                backgroundColor: Colors.grey[300]!,
                              ),
                              Gap(16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(subject.subjectName ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Gap(6.h),
                                    Text(
                                        "${'total_quizzes'.tr}: ${subject.totalQuizzes}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    Text(
                                        "${'taken_quizzes'.tr}: ${subject.takenQuizzes}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
