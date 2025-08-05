import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/widgets/class_list_view.dart';
import 'package:teacher_panel/screens/home_screen/widgets/dashboard_state_cards.dart';
import 'package:teacher_panel/screens/home_screen/widgets/home_end_drawer.dart';
import 'package:teacher_panel/screens/home_screen/widgets/profile_header_card.dart';
import 'package:teacher_panel/screens/home_screen/widgets/quick_action_row.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
        title: 'dashboard'.tr,
        onPressed: () => Get.back(),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(CupertinoIcons.person_circle_fill));
            },
          ),
          Gap(4.w)
        ],
      ),
      endDrawer: const HomeEndDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(16.h),
              const ProfileHeaderCard(),
              Gap(16.h),
              const DashboardStateCards(),
              Gap(16.h),
              Text('your_classes'.tr,
                  style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              const ClassListView(),
              Gap(16.h),
              Text('quick_actions'.tr,
                  style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              const QuickActionRow(),
              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }
}
