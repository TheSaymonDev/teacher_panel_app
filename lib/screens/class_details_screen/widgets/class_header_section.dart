import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/widgets/custom_gradient_container.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';

class ClassHeaderSection extends StatelessWidget {
  ClassHeaderSection({super.key});

  final _controller = Get.find<ClassDetailsController>();

  @override
  Widget build(BuildContext context) {
    return CustomGradientContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(Icons.class_, size: 40.sp, color: AppColors.primaryClr),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_controller.classData.className ?? 'unnamed_class'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)),
                Gap(8.h),
                Row(
                  children: [
                    Icon(Icons.book, size: 20.sp, color: Colors.white),
                    Gap(8.w),
                    GetBuilder<ClassDetailsController>(builder: (controller) {
                      return Text('${'subjects_count'.tr} ${controller.subjectsData.length}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white));
                    }),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    Icon(Icons.group, size: 20.sp, color: Colors.white),
                    Gap(8.w),
                    Text('${'students_count'.tr} ${_controller.classData.numOfStudents}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
