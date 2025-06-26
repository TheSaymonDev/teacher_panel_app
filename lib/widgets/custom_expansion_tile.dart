import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/utils/app_colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget trailing;
  final Widget expandedContent; // Expanded content for details
  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.trailing,
    required this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: context.isDarkMode
              ? AppColors.lightGreyClr
              : AppColors.darkGreyClr,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 24.w),
        childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        iconColor: AppColors.secondaryClr,
        collapsedIconColor: AppColors.secondaryClr,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          subTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: trailing,
        children: [
          expandedContent,
        ],
      ),
    );
  }
}
