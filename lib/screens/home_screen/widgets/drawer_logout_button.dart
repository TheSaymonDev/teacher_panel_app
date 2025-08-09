import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/data/services/shared_preference_service.dart';

class DrawerLogoutButton extends StatelessWidget {
  const DrawerLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
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
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.power, color: AppColors.secondaryClr),
            Gap(8.w),
            Text(
              'logout'.tr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.secondaryClr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
