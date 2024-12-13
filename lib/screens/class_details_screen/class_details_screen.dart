import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';
import 'package:teacher_panel/screens/class_details_screen/widgets/upsert_subject_box.dart';
import 'package:teacher_panel/screens/class_report_and_analytics_screen/class_report_and_analytics_screen.dart';
import 'package:teacher_panel/screens/student_details_screen/student_details_screen.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/widgets/custom_gradient_container.dart';
import 'package:teacher_panel/widgets/custom_list_tile.dart';
import 'package:teacher_panel/widgets/custom_pop_up_menu.dart';

class ClassDetailsScreen extends StatelessWidget {
  ClassDetailsScreen({super.key});

  final _classDetailsController = Get.find<ClassDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
        onPressed: () => Get.back(),
        title: 'Class Details',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(16.h),
              _buildHeaderSection(context),
              Gap(20.h),
              Text('Subjects', style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              _buildSubjectsList(context),
              Gap(20.h),
              Text('Reports & Analytics',
                  style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              _buildReports(context),
              Gap(20.h),
              Text('Students', style: Theme.of(context).textTheme.titleMedium),
              Gap(8.h),
              _buildStudentsList(context),
              Gap(32.h)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showUpsertSubjectBox(context),
          label: Text('Create',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white)),
          icon: Icon(CupertinoIcons.add_circled_solid),
          foregroundColor: Colors.white),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return CustomGradientContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(Icons.class_, size: 40.sp, color: AppColors.primaryClr),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_classDetailsController.classData.className!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)),
                Gap(8.h),
                Row(
                  children: [
                    Icon(Icons.book, size: 20.sp, color: Colors.white),
                    Gap(8.w),
                    GetBuilder<ClassDetailsController>(builder: (controller) {
                      return Text('Subjects: ${controller.subjects.length}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white));
                    }),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    Icon(Icons.group, size: 20.sp, color: Colors.white),
                    Gap(8.w),
                    Text(
                        'Students: ${_classDetailsController.classData.numOfStudents}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    Icon(Icons.qr_code, size: 20.sp, color: Colors.white),
                    Gap(8.w),
                    Text(
                        'Class Code: ${_classDetailsController.classData.classCode ?? ''}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubjectsList(BuildContext context) {
    return GetBuilder<ClassDetailsController>(
      builder: (controller) => controller.isLoading
          ? AppConstFunctions.customCircularProgressIndicator
          : controller.subjects.isEmpty
              ? CustomEmptyWidget(title: 'No subject added!')
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.subjects.length,
                  itemBuilder: (context, index) {
                    final subjectItem = controller.subjects[index];
                    return CustomListTile(
                      onTap: () => Get.toNamed(
                        AppRoutes.subjectDetailsScreen,
                        arguments: {
                          'classData': _classDetailsController.classData,
                          'subjectData': subjectItem
                        },
                      ),
                      title: subjectItem.subjectName ?? '',
                      subTitle: 'Status: Active',
                      trailing: CustomPopUpMenu(
                        onUpdate: () =>
                            _showUpsertSubjectBox(context, subjectItem),
                        onDelete: () => _showSubjectDeleteConfirmationDialog(
                            context, subjectItem.id!),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap(8.h),
                ),
    );
  }

  void _showUpsertSubjectBox(BuildContext context, [dynamic subjectItem]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (context) => UpsertSubjectBox(
          isUpdate: subjectItem != null,
          classId: _classDetailsController.classId,
          subjectData: subjectItem),
    );
  }

  Widget _buildStudentsList(BuildContext context) {
    final students = [
      {'name': 'John Doe', 'roll': '1'},
      {'name': 'Jane Smith', 'roll': '2'},
      {'name': 'Robert Brown', 'roll': '3'},
    ];

    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            leading: CircleAvatar(
                child: Text(student['roll']!,
                    style: Theme.of(context).textTheme.titleSmall)),
            title: Text(student['name']!,
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Icon(
              Icons.arrow_forward,
              size: 20.sp,
            ),
            onTap: () {
              // Navigate to student details
              Get.to(() => StudentDetailsScreen(
                    student: {'name': 'John Doe', 'roll': '1'},
                  ));
            },
          );
        },
        separatorBuilder: (context, index) => Gap(8.h));
  }

  Widget _buildReports(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ClassReportsAnalyticsScreen(className: 'Class 6'));
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Average Performance',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('85%', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Attendance',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('92%', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubjectDeleteConfirmationDialog(
      BuildContext context, String subjectId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Confirm Delete',
                  style: Theme.of(context).textTheme.titleMedium),
              content: Text('Are you sure you want to delete this subject?',
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
                    final result = await Get.find<ClassDetailsController>()
                        .deleteSubjectById(
                            classId: _classDetailsController.classId,
                            subjectId: subjectId);
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
