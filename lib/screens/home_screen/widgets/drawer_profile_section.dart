import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/core/utils/app_urls.dart';
import 'package:teacher_panel/core/widgets/custom_gradient_container.dart';
import 'package:teacher_panel/screens/home_screen/controllers/teacher_info_controller.dart';

class DrawerProfileSection extends StatelessWidget {
  const DrawerProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherInfoController>(builder: (controller) {
      final teacher = controller.teacherData;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomGradientContainer(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () => Get.toNamed(
                              AppRoutes.profileUpdateScreen,
                              arguments: {'teacherInfo': teacher},
                            ),
                        style: TextButton.styleFrom(
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'edit'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.white),
                        )),
                  ),
                  Gap(8.h),
                  Center(
                    child: Text(
                      teacher.fullName ?? '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  _buildInfoRow(Icons.school,
                      teacher.schoolName ?? 'abc_school'.tr, context),
                ],
              ),
            ),
          ),
          Positioned(
            top: -45.r, // Half of radius to make it half outside
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 45.r,
                backgroundImage:
                    (teacher.imageUrl == null || teacher.imageUrl!.isEmpty)
                        ? AssetImage(AppUrls.demoProfile) as ImageProvider
                        : MemoryImage(base64Decode(teacher.imageUrl!)),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: Colors.white),
          Gap(8.w),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
