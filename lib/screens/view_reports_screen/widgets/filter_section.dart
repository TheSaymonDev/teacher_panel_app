import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/view_reports_screen/controllers/view_reports_controller.dart';

class FilterSection extends StatelessWidget {
  FilterSection({super.key});
  final _controller = Get.find<ViewReportsController>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GetBuilder<ViewReportsController>(
                  builder: (controller) {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedClass,
                      decoration: InputDecoration(
                        hintText: 'select_class'.tr,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 14.h),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'class_required'.tr
                          : null,
                      items: controller.classesData
                          .map((cls) => DropdownMenuItem<String>(
                                value: cls.className,
                                child: Text(cls.className ?? ''),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.onClassSelected(value);
                        }
                      },
                    );
                  },
                ),
              ),
              Gap(8.w),
              Expanded(
                child: GetBuilder<ViewReportsController>(
                  builder: (controller) {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedSubject,
                      decoration: InputDecoration(
                        hintText: 'select_subject'.tr,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 14.h),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'subject_required'.tr
                          : null,
                      items: controller.subjectsData
                          .map((sub) => DropdownMenuItem<String>(
                                value: sub.subjectName,
                                child: Text(sub.subjectName ?? ''),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.onSubjectSelected(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Gap(12.h),
          GetBuilder<ViewReportsController>(
            builder: (controller) {
              return DropdownButtonFormField<String>(
                value: controller.selectedRange,
                decoration: InputDecoration(
                  hintText: 'select_range'.tr,
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'range_required'.tr : null,
                items: controller.dateRanges
                    .map((range) => DropdownMenuItem<String>(
                          value: range.value,
                          child: Text(range.title),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.onRangeSelected(value);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
