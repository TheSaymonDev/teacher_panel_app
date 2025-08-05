import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teacher_panel/core/widgets/custom_empty_widget.dart';
import 'package:teacher_panel/core/widgets/custom_list_tile.dart';
import 'package:teacher_panel/core/widgets/custom_pop_up_menu.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'upsert_subject_box.dart';

class SubjectListSection extends StatelessWidget {
  SubjectListSection({super.key});
  final _controller = Get.find<ClassDetailsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassDetailsController>(
      builder: (controller) {
        if (controller.isLoading) {
          return AppConstFunctions.customCircularProgressIndicator;
        } else if (controller.subjects.isEmpty) {
          return CustomEmptyWidget(title: 'no_subject_added'.tr);
        } else {
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.subjects.length,
            itemBuilder: (_, index) {
              final subject = controller.subjects[index];
              return CustomListTile(
                title: subject.subjectName ?? '',
                subTitle: 'status_active'.tr,
                onTap: () =>
                    Get.toNamed(AppRoutes.subjectDetailsScreen, arguments: {
                  'classData': _controller.classData,
                  'subjectData': subject,
                }),
                trailing: CustomPopUpMenu(
                  onUpdate: () => _showUpsertSubject(context, subject),
                  onDelete: () => _confirmDelete(context, subject.id!),
                ),
              );
            },
            separatorBuilder: (_, __) => Gap(8.h),
          );
        }
      },
    );
  }

  void _showUpsertSubject(BuildContext context, dynamic subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))),
      builder: (_) => UpsertSubjectBox(
        isUpdate: true,
        classId: _controller.classId,
        subjectData: subject,
      ),
    );
  }

  void _confirmDelete(BuildContext context, String subjectId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('confirm_delete'.tr),
        content: Text('delete_subject_confirmation'.tr),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () async {
              final success = await _controller.deleteSubjectById(
                  classId: _controller.classId, subjectId: subjectId);
              if (success && context.mounted) Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('delete'.tr, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
