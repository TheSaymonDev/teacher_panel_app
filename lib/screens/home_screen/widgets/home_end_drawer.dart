import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:teacher_panel/utils/app_colors.dart';

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Gap(48.h),
          Icon(Icons.person, color: primaryClr, size: 100.sp),
          Text('MD. SAYMON', style: Theme.of(context).textTheme.titleLarge),
          Gap(16.h),
          Divider(
            color: Colors.grey,
            thickness: 1.h,
          ),
          // GetBuilder<LanguageController>(builder: (controller) {
          //   return ListTile(
          //     title: Text(controller.isEnglish ? 'English' : 'বাংলা',
          //         style: Theme.of(context).textTheme.bodyMedium),
          //     leading: const Icon(Icons.language),
          //     trailing: Transform.scale(
          //       scale: 0.8,
          //       child: CupertinoSwitch(
          //           activeTrackColor: primaryClr,
          //           value: controller.isEnglish,
          //           onChanged: (newValue) => controller.changeLanguage()),
          //     ),
          //   );
          // }),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: secondaryClr, width: 2.w),
                foregroundColor: secondaryClr,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r))),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.power, color: secondaryClr),
                  Gap(8.w),
                  Text('Logout',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: secondaryClr))
                ],
              ))
        ],
      ),
    );
  }
}
