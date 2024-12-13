import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/screens/home_screen/controllers/manage_class_controller.dart';
import 'package:teacher_panel/screens/home_screen/widgets/home_end_drawer.dart';
import 'package:teacher_panel/screens/home_screen/widgets/quick_action_card.dart';
import 'package:teacher_panel/screens/home_screen/widgets/state_card.dart';
import 'package:teacher_panel/screens/home_screen/widgets/upsert_class_box.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/widgets/custom_gradient_container.dart';
import 'package:teacher_panel/widgets/custom_list_tile.dart';
import 'package:teacher_panel/widgets/custom_pop_up_menu.dart';

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
              CustomGradientContainer(
                  child: Text(
                'Welcome, John Doe!',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              )),
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
                      onTap: () => _showUpsertClassBox(context),
                      title: 'Create Class',
                      iconData: Icons.add),
                  QuickActionCard(
                      onTap: () => Get.toNamed(AppRoutes.viewReportsScreen),
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
    return GetBuilder<ManageClassController>(
      builder: (controller) => controller.isLoading
          ? AppConstFunctions.customCircularProgressIndicator
          : controller.classes.isEmpty
              ? CustomEmptyWidget(title: 'No class added!')
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.classes.length,
                  itemBuilder: (context, index) {
                    final classItem = controller.classes[index];
                    return CustomListTile(
                      onTap: () => Get.toNamed(
                        AppRoutes.classDetailsScreen,
                        arguments: {'classData': classItem},
                      ),
                      title: classItem.className ?? '',
                      subTitle: 'Total Student: ${classItem.numOfStudents}',
                      trailing: CustomPopUpMenu(
                        onUpdate: () => _showUpsertClassBox(context, classItem),
                        onDelete: () => _showClassDeleteConfirmationDialog(
                            context, classItem.id!),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap(8.h),
                ),
    );
  }

  /// Shows a modal bottom sheet for adding or updating a class.
  void _showUpsertClassBox(BuildContext context, [dynamic classItem]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (context) => UpsertClassBox(
        isUpdate: classItem != null,
        classData: classItem,
      ),
    );
  }


  void _showClassDeleteConfirmationDialog(
      BuildContext context, String classId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Confirm Delete',
                  style: Theme.of(context).textTheme.titleMedium),
              content: Text('Are you sure you want to delete this class?',
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Get.find<ManageClassController>()
                        .deleteClassById(classId: classId);
                    if (result && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryClr),
                  child: Text('Delete',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ));
  }
}
