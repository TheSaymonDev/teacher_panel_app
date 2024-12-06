import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/class_report_and_analytics_screen/class_report_and_analytics_screen.dart';
import 'package:teacher_panel/screens/student_details_screen/student_details_screen.dart';
import 'package:teacher_panel/screens/subject_details_screen/subject_details_screen.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/widgets/custom_app_bar_with_title.dart';

class ClassDetailsScreen extends StatelessWidget {
  const ClassDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () {
            Get.back();
          },
          title: 'Class Details',
          actions: [
            IconButton(
                onPressed: () {},
                icon:
                    Icon(Icons.edit, size: 20.sp, color: AppColors.primaryClr)),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete,
                    size: 20.sp, color: AppColors.secondaryClr)),
          ]),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new subject
        },
        tooltip: 'Add Subject',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryClr.withValues(alpha: 0.8),
              AppColors.secondaryClr.withValues(alpha: 0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child:
                  Icon(Icons.class_, size: 40.sp, color: AppColors.primaryClr),
            ),
            Gap(16.w),

            // Text Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Class 6',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white)),
                  Gap(8.h),
                  Row(
                    children: [
                      Icon(Icons.book, size: 20.sp, color: Colors.white),
                      Gap(8.w),
                      Text('Subjects: 5',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                  Gap(8.h),
                  Row(
                    children: [
                      Icon(Icons.group, size: 20.sp, color: Colors.white),
                      Gap(8.w),
                      Text('Students: 30',
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
                      Text('Class ID: CL6-12345',
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
      ),
    );
  }

  Widget _buildSubjectsList(BuildContext context) {
    final subjects = [
      {'name': 'Mathematics', 'status': 'Active'},
      {'name': 'Science', 'status': 'Active'},
      {'name': 'History', 'status': 'Inactive'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                  width: 1.5,
                  color: context.isDarkMode
                      ? AppColors.lightGreyClr
                      : AppColors.darkGreyClr)),
          title: Text(subject['name']!,
              style: Theme.of(context).textTheme.bodyMedium),
          subtitle: Text('Status: ${subject['status']}',
              style: Theme.of(context).textTheme.titleSmall),
          trailing: Icon(
            Icons.arrow_forward,
            size: 20.sp,
          ),
          onTap: () {
            Get.to(SubjectDetailsScreen(
                subjectName: 'Math', className: 'Class 8'));
            // Navigate to subject details
          },
        );
      },
      separatorBuilder: (context, index) => Gap(8.h),
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
}
