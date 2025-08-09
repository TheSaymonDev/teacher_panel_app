import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/core/widgets/custom_list_tile.dart';
import 'package:teacher_panel/core/widgets/custom_pop_up_menu.dart';
import 'package:teacher_panel/screens/home_screen/controllers/manage_class_controller.dart';
import 'package:teacher_panel/screens/home_screen/widgets/upsert_class_box.dart';

class ClassListView extends StatelessWidget {
  const ClassListView({super.key});

  void _showUpsertClassBox(BuildContext context, [dynamic classItem]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
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
        title: Text('confirm_delete'.tr),
        content: Text('delete_class_confirmation'.tr),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () async {
              final result = await Get.find<ManageClassController>()
                  .deleteClassById(classId: classId);
              if (result && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('delete'.tr, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageClassController>(
      builder: (controller) => controller.isLoading
          ? AppConstFunctions.customCircularProgressIndicator
          : controller.classesData.isEmpty
              ? CustomEmptyWidget(title: 'no_class_added'.tr)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.classesData.length,
                  itemBuilder: (context, index) {
                    final classItem = controller.classesData[index];
                    return CustomListTile(
                      onTap: () => Get.toNamed(AppRoutes.classDetailsScreen,
                          arguments: {'classData': classItem}),
                      title: classItem.className ?? '',
                      subTitle: '${'total_student'.tr} ${classItem.numOfStudents}',
                      trailing: CustomPopUpMenu(
                        onUpdate: () => _showUpsertClassBox(context, classItem),
                        onDelete: () => _showClassDeleteConfirmationDialog(
                            context, classItem.id!),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                ),
    );
  }
}
