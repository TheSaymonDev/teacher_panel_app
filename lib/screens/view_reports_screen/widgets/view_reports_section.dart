import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/screens/view_reports_screen/controllers/view_reports_controller.dart';
import 'package:teacher_panel/screens/view_reports_screen/widgets/quiz_score_bar_chart.dart';

class ViewReportsSection extends StatelessWidget {
  const ViewReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<ViewReportsController>(
        builder: (controller) => controller.isLoading
            ? AppConstFunctions.customCircularProgressIndicator
            : controller.reports.isEmpty
                ? CustomEmptyWidget(title: 'no_reports_available'.tr)
                : QuizScoreBarChart(
                    avgScores: controller.reports.map((e) => e.avgScore).toList(),
                    quizTitles:
                        controller.reports.map((e) => e.quizTitle).toList(),
                  ),
      ),
    );
  }
}
