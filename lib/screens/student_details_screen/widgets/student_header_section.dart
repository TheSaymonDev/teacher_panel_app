import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/student_details_screen/controllers/student_performance_controller.dart';

class StudentHeaderSection extends StatelessWidget {
  StudentHeaderSection({super.key});
  final _controller = Get.find<StudentPerformanceController>();
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundImage: NetworkImage(
                'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D', // Replace with student's image URL
              ),
              backgroundColor: Colors.grey.shade200,
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _controller.student.name ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Gap(4.h),
                  Text(
                    '${'class_roll'.tr}: 10',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    _controller.student.className ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.info_outline,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
