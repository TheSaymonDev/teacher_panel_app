import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/controllers/manage_class_controller.dart';
import 'package:teacher_panel/screens/home_screen/widgets/state_card.dart';

class DashboardStateCards extends StatelessWidget {
  const DashboardStateCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageClassController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StateCard(title: 'classes'.tr, value: '${controller.totalClasses}', color: const Color(0xFFfe4a49)),
          StateCard(title: 'subjects'.tr, value: '${controller.totalSubjects}', color: const Color(0xFF2ab7ca)),
          StateCard(title: 'students'.tr, value: '${controller.totalStudents}', color: const Color(0xFFfed766)),
        ],
      );
    });
  }
}
