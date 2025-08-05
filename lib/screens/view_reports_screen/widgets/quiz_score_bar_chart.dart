import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';

class QuizScoreBarChart extends StatelessWidget {
  final List<double> avgScores;
  final List<String> quizTitles;

  const QuizScoreBarChart({
    super.key,
    required this.avgScores,
    required this.quizTitles,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.isDarkMode
              ? AppColors.darkCardClr
              : AppColors.lightCardClr,
        ),
        height: 420.h,
        width: avgScores.length * 80.w, // dynamically adjusting width
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40.w,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= quizTitles.length) return const SizedBox();
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 0.h,
                      child: SizedBox(
                        width: 75.w,
                        child: Text(
                          quizTitles[index],
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 2, // Allow up to 2 lines
                          overflow:
                              TextOverflow.visible, // Let it wrap naturally
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: avgScores
                .asMap()
                .entries
                .map(
                  (entry) => BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: AppColors.primaryClr,
                        width: 20.w,
                        borderRadius: BorderRadius.circular(6.r),
                      )
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
