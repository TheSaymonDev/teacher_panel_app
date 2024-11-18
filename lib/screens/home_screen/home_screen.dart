import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/screens/home_screen/widgets/home_end_drawer.dart';
import 'package:teacher_panel/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryClr,
        toolbarHeight: 56.h,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.arrow_left_circle_fill,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text('স্বাগতম সায়মন স্যার',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: secondaryClr)),
        actions: [
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(CupertinoIcons.person_circle_fill,
                    color: Colors.white));
          }),
          Gap(4.w)
        ],
      ),
      endDrawer: HomeEndDrawer(),
      body: Container(
        height: double.infinity.h,
        width: double.infinity.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.questionScreen);
                },
                child: Text('General Knowledge'))
          ],
        ),
      ),
    );
  }
}
