import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_urls.dart';
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
              backgroundImage: (_controller.studentData.imageUrl == null ||
                  _controller.studentData.imageUrl!.isEmpty)
                  ? AssetImage(AppUrls.demoProfile) as ImageProvider
                  : MemoryImage(base64Decode(_controller.studentData.imageUrl!)),
              backgroundColor: Colors.grey.shade200,
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _controller.studentData.studentName ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Gap(4.h),
                  Text(
                    '${'class_roll'.tr}: 10',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    _controller.studentData.className ?? '',
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
