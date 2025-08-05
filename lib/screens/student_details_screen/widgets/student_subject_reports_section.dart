import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/core/widgets/custom_list_tile.dart';
import 'package:teacher_panel/screens/student_details_screen/controllers/student_subject_reports_controller.dart';

class StudentSubjectReportsSection extends StatelessWidget {
  const StudentSubjectReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentSubjectReportsController>(
      builder: (controller) => controller.isLoading
          ? AppConstFunctions.customCircularProgressIndicator
          : controller.subjectReports.isEmpty
              ? CustomEmptyWidget(title: 'no_subject_added'.tr)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.subjectReports.length,
                  itemBuilder: (context, index) {
                    final report = controller.subjectReports[index];
                    return CustomListTile(
                      onTap: () {},
                      title: report.subjectName ?? '',
                      subTitle: '${report.topics ?? 0} ${'topics'.tr}',
                      trailing: FittedBox(
                        child: CircularPercentIndicator(
                          radius: 35.0.r,
                          lineWidth: 6.0,
                          animation: true,
                          animationDuration: 1500,
                          percent: (report.score ?? 0) / 100, // ✅ fix here
                          center: Text(
                            '${(report.score ?? 0).toInt()}%',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.green,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap(8.h),
                ),
    );
  }
}
