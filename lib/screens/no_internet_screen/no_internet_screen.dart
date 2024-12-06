import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/screens/no_internet_screen/controllers/connection_controller.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/widgets/custom_elevated_btn.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Image.asset('assets/images/no_internet.png', width: 150.w),
            Gap(32.h),
            Text(
              'Whoops!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 35.sp, color: AppColors.secondaryClr),
            ),
            Gap(16.h),
            Text(
              'No internet connection found\nPlease check your internet settings',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Gap(32.h),
            GetBuilder<ConnectionController>(
                builder: (controller) => controller.isLoading
                    ? AppConstFunctions.customCircularProgressIndicator
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: CustomElevatedBtn(
                            onPressed: () {
                              controller.checkConnection();
                            },
                            name: 'Reload',),
                      ))
          ],
        ),
      ),
    );
  }
}
