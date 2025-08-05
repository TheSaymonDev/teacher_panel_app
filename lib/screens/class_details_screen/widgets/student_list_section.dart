import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/students_info_controller.dart';

class StudentListSection extends StatelessWidget {
  const StudentListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentsInfoController>(
        builder: (controller) => controller.isLoading
            ? AppConstFunctions.customCircularProgressIndicator
            : controller.studentsInfo.isEmpty
                ? CustomEmptyWidget(title: 'no_student_found'.tr)
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.studentsInfo.length,
                    itemBuilder: (context, index) {
                      final student = controller.studentsInfo[index];
                      return ListTile(
                        leading: CircleAvatar(
                            child: Text('${index + 1}',
                                style: Theme.of(context).textTheme.titleSmall)),
                        title: Text(student.name ?? '',
                            style: Theme.of(context).textTheme.bodyMedium),
                        trailing: Icon(
                          Icons.arrow_forward,
                          size: 20.sp,
                        ),
                        onTap: () => Get.toNamed(AppRoutes.studentDetailsScreen,
                            arguments: {
                              'student': student,
                              'classId': controller.classId
                            }),
                      );
                    },
                    separatorBuilder: (context, index) => Gap(8.h)));
  }
}
