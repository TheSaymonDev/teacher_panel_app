import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/utils/app_urls.dart';
import 'package:teacher_panel/screens/home_screen/controllers/teacher_info_controller.dart';

class DrawerProfileSection extends StatelessWidget {
  const DrawerProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherInfoController>(
      builder: (controller) {
        final teacherInfo = controller.teacherInfo;
        return Column(
          children: [
            CircleAvatar(
              radius: 45.r,
              backgroundImage: (teacherInfo.imageUrl == null ||
                      teacherInfo.imageUrl!.isEmpty)
                  ? AssetImage(AppUrls.demoProfile) as ImageProvider
                  : MemoryImage(base64Decode(teacherInfo.imageUrl!)),
              backgroundColor: AppColors.primaryClr.withValues(alpha: 0.1),
            ),
            Gap(12.h),
            Text(teacherInfo.fullName!,
                style: Theme.of(context).textTheme.titleLarge),
            Gap(4.h),
            Text(teacherInfo.schoolName!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey)),
            TextButton.icon(
                onPressed: () => Get.toNamed(
                      AppRoutes.profileUpdateScreen,
                      arguments: {'teacherInfo': teacherInfo},
                    ),
                icon: Icon(Icons.edit),
                label: Text('Edit'))
          ],
        );
      },
    );
  }
}
