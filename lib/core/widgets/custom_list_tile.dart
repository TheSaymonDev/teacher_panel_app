import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final String subTitle;
  final Widget trailing;
  const CustomListTile(
      {super.key,
      required this.onTap,
      required this.title,
      required this.subTitle,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
                width: 1.5,
                color: context.isDarkMode
                    ? AppColors.lightGreyClr
                    : AppColors.darkGreyClr)),
        onTap: onTap,
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(subTitle, style: Theme.of(context).textTheme.titleSmall),
        trailing: trailing);
  }
}
