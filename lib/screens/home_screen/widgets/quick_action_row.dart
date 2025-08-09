import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/screens/home_screen/controllers/manage_class_controller.dart';
import 'package:teacher_panel/screens/home_screen/widgets/quick_action_card.dart';
import 'package:teacher_panel/screens/home_screen/widgets/upsert_class_box.dart';

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key});

  void _showUpsertClassBox(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
      builder: (context) => const UpsertClassBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        QuickActionCard(
          onTap: () => _showUpsertClassBox(context),
          title: 'create_class'.tr,
          iconData: Icons.add,
        ),
        QuickActionCard(
          onTap: () => Get.toNamed(
            AppRoutes.viewReportsScreen,
            arguments: {
              'classes': Get.find<ManageClassController>().classesData,
            },
          ),
          title: 'view_reports'.tr,
          iconData: Icons.pie_chart,
        ),
      ],
    );
  }
}
