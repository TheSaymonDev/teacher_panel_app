import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/view_reports_screen/controllers/view_reports_controller.dart';
import 'package:teacher_panel/screens/view_reports_screen/widgets/filter_section.dart';
import 'package:teacher_panel/core/widgets/custom_app_bar_with_title.dart';
import 'package:teacher_panel/core/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/screens/view_reports_screen/widgets/view_reports_section.dart';

class ViewReportsScreen extends StatelessWidget {
  ViewReportsScreen({super.key});

  final _controller = Get.find<ViewReportsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitle(
          onPressed: () => Get.back(), title: 'view_reports'.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          children: [
            FilterSection(),
            Gap(20.h),
            CustomElevatedBtn(
                onPressed: () async{
                  if (_controller.formKey.currentState!.validate()) {
                    await _controller.fetchReports();
                  }
                },
                name: 'filter'.tr),
            Gap(40.h),
            Text("analytics_overview".tr,
                style: Theme.of(context).textTheme.titleMedium),
            Gap(20.h),
            ViewReportsSection()
          ],
        ),
      ),
    );
  }
}
