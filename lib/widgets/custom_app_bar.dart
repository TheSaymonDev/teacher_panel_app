import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teacher_panel/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final void Function() onPressed;
  final String title;
  const CustomAppBar({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryClr,
      toolbarHeight: preferredSize.height,
      leading: IconButton(
          onPressed: onPressed,
          icon: Icon(
            CupertinoIcons.arrow_left_circle_fill,
            color: Colors.white,
          )),
      centerTitle: true,
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: secondaryClr)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
