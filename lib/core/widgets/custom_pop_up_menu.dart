import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_colors.dart';

class CustomPopUpMenu extends StatelessWidget {
  final void Function() onUpdate;
  final void Function() onDelete;
  const CustomPopUpMenu(
      {super.key, required this.onUpdate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: FittedBox(
        child: PopupMenuButton<int>(
          borderRadius: BorderRadius.circular(12.r),
          color: context.isDarkMode
              ? AppColors.darkCardClr
              : AppColors.lightCardClr,
          iconSize: 60.sp,
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
          menuPadding: EdgeInsets.zero,
          onSelected: (value) {
            if (value == 1) {
              onUpdate();
            } else if (value == 2) {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 40.h,
              value: 1,
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: AppColors.primaryClr,
                    size: 20.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Update',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              height: 40.h,
              value: 2,
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: AppColors.secondaryClr,
                    size: 20.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Delete',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
