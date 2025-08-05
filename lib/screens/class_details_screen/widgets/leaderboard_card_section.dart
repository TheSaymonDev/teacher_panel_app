import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/widgets/custom_gradient_container.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';

class LeaderboardCardSection extends StatelessWidget {
  LeaderboardCardSection({super.key});

  final _controller = Get.find<ClassDetailsController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.leaderboardScreen,
        arguments: {
          'classId': _controller.classId,
        },
      ),
      child: CustomGradientContainer(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events,
                color: AppColors.primaryClr,
                size: 30.sp,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("leaderboard".tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white)),
                  Gap(4.h),
                  Text("see_top_performing_students".tr,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          )),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
