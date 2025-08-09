import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/widgets/custom_gradient_container.dart';
import 'package:teacher_panel/screens/home_screen/controllers/teacher_info_controller.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradientContainer(
      child: GetBuilder<TeacherInfoController>(
        builder: (controller) {
          final teacherInfo = controller.teacherData;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcome_back'.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
              Gap(4.h),
              Text(
                teacherInfo.fullName ?? '',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
              Gap(6.h),
              Row(
                children: [
                  Icon(Icons.school, color: Colors.white70, size: 20.sp),
                  Gap(6.w),
                  Expanded(
                    child: Text(
                      teacherInfo.schoolName ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
