import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:teacher_panel/utils/app_colors.dart';

class QuickActionCard extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final IconData iconData;
  const QuickActionCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: SizedBox(
            height: 160.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, color: AppColors.primaryClr, size: 50.sp),
                Gap(16.h),
                Text(title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
