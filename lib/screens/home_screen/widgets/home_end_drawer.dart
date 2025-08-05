import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:teacher_panel/screens/home_screen/widgets/drawer_logout_button.dart';
import 'package:teacher_panel/screens/home_screen/widgets/drawer_profile_section.dart';
import 'package:teacher_panel/screens/home_screen/widgets/drawer_settings_card.dart';

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Gap(48.h),
          const DrawerProfileSection(),
          const Divider(),
          const DrawerSettingsCard(),
          const Spacer(),
          const DrawerLogoutButton(),
          Gap(32.h),
        ],
      ),
    );
  }
}
