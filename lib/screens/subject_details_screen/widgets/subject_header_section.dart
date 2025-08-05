import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/widgets/custom_gradient_container.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_details_controller.dart';

class SubjectHeaderSection extends StatelessWidget {
  SubjectHeaderSection({super.key});
  final _controller = Get.find<SubjectDetailsController>();
  @override
  Widget build(BuildContext context) {
    return CustomGradientContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.subjectData.subjectName ?? '',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          Divider(color: Colors.white, thickness: 1.0),
          Gap(8.h),
          Row(
            children: [
              Icon(Icons.class_, size: 20.sp, color: Colors.white),
              Gap(8.w),
              Text(
                "${'class_label'.tr}: ${_controller.classData.className}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
          Gap(8.h),
          GetBuilder<SubjectDetailsController>(
            builder: (controller) => Row(
              children: [
                Icon(Icons.quiz, size: 20.sp, color: Colors.white),
                Gap(8.w),
                Text(
                  "${'total_quizzes'.tr}: ${controller.quizzes.length}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
