import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/screens/home_screen/controllers/read_classes_controller.dart';
import 'package:teacher_panel/screens/home_screen/widgets/home_end_drawer.dart';
import 'package:teacher_panel/screens/home_screen/widgets/quick_action_card.dart';
import 'package:teacher_panel/screens/home_screen/widgets/state_card.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      endDrawer: HomeEndDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(16.h),
              Container(
                width: double.infinity.w,
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: context.isDarkMode
                        ? [AppColors.primaryClr, AppColors.secondaryClr]
                        : [Colors.lightBlueAccent, Colors.greenAccent],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Welcome, John Doe!',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Gap(16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 8.w,
                children: [
                  StateCard(
                    title: 'Classes',
                    value: '5',
                    color: Color(0xFFfe4a49),
                  ),
                  StateCard(
                    title: 'Subjects',
                    value: '20',
                    color: Color(0xFF2ab7ca),
                  ),
                  StateCard(
                    title: 'Students',
                    value: '150',
                    color: Color(0xFFfed766),
                  ),
                ],
              ),
              Gap(16.h),
              Text('Your Classes',
                  style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              _buildClassList(context),
              Gap(16.h),
              Text('Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 8.w,
                children: [
                  QuickActionCard(
                      onTap: () {
                        Get.toNamed(AppRoutes.addClassScreen);
                      },
                      title: 'Add Class',
                      iconData: Icons.add),
                  QuickActionCard(
                      onTap: () {
                        Get.toNamed(AppRoutes.viewReportsScreen);
                      },
                      title: 'View Reports',
                      iconData: Icons.pie_chart),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 56.h,
      leading: IconButton(
          onPressed: () {}, icon: Icon(CupertinoIcons.arrow_left_circle_fill)),
      actions: [
        Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(CupertinoIcons.person_circle_fill));
        }),
        Gap(4.w)
      ],
    );
  }

  Widget _buildClassList(BuildContext context) {
    return GetBuilder<ReadClassesController>(
        builder: (controller) => controller.isLoading
            ? AppConstFunctions.customCircularProgressIndicator
            : controller.classes.isEmpty
                ? Center(
                    child: Text('No Class Added',
                        style: Theme.of(context).textTheme.bodyMedium),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.classes.length,
                    itemBuilder: (context, index) {
                      final classItem = controller.classes[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 0.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                                width: 1.5,
                                color: context.isDarkMode
                                    ? AppColors.lightGreyClr
                                    : AppColors.darkGreyClr)),
                        title: Text(classItem.className!,
                            style: Theme.of(context).textTheme.bodyMedium),
                        subtitle: Text('${classItem.subjects!.length} Subjects',
                            style: Theme.of(context).textTheme.titleSmall),
                        trailing: Icon(
                          Icons.arrow_forward,
                          size: 20.sp,
                        ),
                        onTap: () {
                         Get.toNamed(AppRoutes.classDetailsScreen, arguments: {
                           'classData': classItem
                         });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Gap(8.h),
                  ));
  }
}
