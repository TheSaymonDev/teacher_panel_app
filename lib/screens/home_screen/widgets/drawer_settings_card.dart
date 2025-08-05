import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/controllers/language_controller.dart';
import 'package:teacher_panel/core/controllers/theme_controller.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/core/widgets/custom_switch.dart';

class DrawerSettingsCard extends StatelessWidget {
  const DrawerSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? AppColors.darkCardClr
            : AppColors.lightCardClr,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDarkMode
              ? AppColors.lightGreyClr
              : AppColors.darkGreyClr,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('Theme', style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              GetBuilder<ThemeController>(
                builder: (controller) => CustomSwitch(
                  current: controller.isDark,
                  onChanged: (_) => controller.changeTheme(),
                  iconBuilder: (value) => Icon(
                    value ? Icons.dark_mode : Icons.light_mode,
                    size: 20.0.sp,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: AppColors.lightGreyClr),
          Row(
            children: [
              Text('Language', style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              GetBuilder<LanguageController>(
                builder: (controller) => CustomSwitch(
                  current: controller.isEnglish,
                  onChanged: (_) => controller.changeLanguage(),
                  iconBuilder: (value) => Center(
                    child: Text(value ? 'En' : 'বাং',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
