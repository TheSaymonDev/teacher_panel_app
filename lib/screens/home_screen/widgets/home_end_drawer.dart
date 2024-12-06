import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/localizations/language_controller.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/services/shared_preference_service.dart';
import 'package:teacher_panel/themes/theme_controller.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/widgets/custom_switch.dart';

class HomeEndDrawer extends StatefulWidget {
  const HomeEndDrawer({super.key});

  @override
  State<HomeEndDrawer> createState() => _HomeEndDrawerState();
}

class _HomeEndDrawerState extends State<HomeEndDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Gap(48.h),
          Icon(Icons.person, color: AppColors.primaryClr, size: 100.sp),
          Text('MD. SAYMON', style: Theme.of(context).textTheme.titleLarge),
          Gap(16.h),
          Divider(
            color: Colors.grey,
            thickness: 1.h,
          ),
          Container(
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
                        : AppColors.darkGreyClr)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Theme',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Spacer(),
                    GetBuilder<ThemeController>(builder: (controller) {
                      return CustomSwitch(
                          current: controller.isDark,
                          onChanged: (newValue) => controller.changeTheme(),
                        iconBuilder: (value) => Icon(
                          value ? Icons.dark_mode : Icons.light_mode,
                          size: 20.0.sp,
                        ));
                    })
                  ],
                ),
                Divider(
                    color: context.isDarkMode
                        ? AppColors.lightGreyClr
                        : AppColors.darkGreyClr),
                Row(
                  children: [
                    Text('Language',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Spacer(),
                    GetBuilder<LanguageController>(builder: (controller) {
                      return CustomSwitch(
                          current: controller.isEnglish,
                          onChanged: (newValue) => controller.changeLanguage(),
                          iconBuilder: (value) => Center(
                                child: Text(value ? 'En' : 'বাং',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ));
                    })
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          _buildLogoutBtn(context),
          Gap(32.h)
        ],
      ),
    );
  }

  Padding _buildLogoutBtn(BuildContext context) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: OutlinedButton(
              onPressed: () {
                FirebaseService().signOut();
                SharedPreferencesService().clearUserId();
                Get.offAllNamed(AppRoutes.logInScreen);
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.secondaryClr, width: 2.w),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.power, color: AppColors.secondaryClr),
                  Gap(8.w),
                  Text('Logout',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.secondaryClr))
                ],
              )),
        );
  }
}
