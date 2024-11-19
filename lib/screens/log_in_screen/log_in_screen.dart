import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/screens/log_in_screen/controllers/log_in_controller.dart';
import 'package:teacher_panel/utils/app_colors.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';
import 'package:teacher_panel/utils/app_validators.dart';
import 'package:teacher_panel/widgets/custom_elevated_btn.dart';
import 'package:teacher_panel/widgets/custom_text_form_field.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final _logInController = Get.find<LogInController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: SingleChildScrollView(
          child: Form(
            key: _logInController.formKey,
            child: Column(
              children: [
                Gap(200.h),
                Image.asset('assets/images/book.png', width: 75.w),
                Gap(16.h),
                Text('Educora', style: Theme.of(context).textTheme.bodyLarge),
                Gap(8.h),
                Text('Online learning platform',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: secondaryClr)),
                Gap(48.h),
                CustomTextFormField(
                    controller: _logInController.emailController,
                    hintText: 'Email Address',
                    validator: AppValidators.emailValidator),
                Gap(16.h),
                GetBuilder<LogInController>(builder: (controller) {
                  return CustomTextFormField(
                      controller: controller.passwordController,
                      hintText: 'Password',
                      validator: AppValidators.passwordValidator,
                      obscureText: controller.isObscure,
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.toggleObscure();
                          },
                          icon: Icon(
                              controller.isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey)));
                }),
                Gap(32.h),
                GetBuilder<LogInController>(
                    builder: (controller) => controller.isLoading
                        ? AppConstFunctions.customCircularProgressIndicator
                        : CustomElevatedBtn(
                            onPressed: () {
                              _formOnSubmit(controller);
                            },
                            name: 'Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _formOnSubmit(LogInController controller) async{
   if(controller.formKey.currentState!.validate()){
     final result = await controller.logInUser();
     if(result){
       Get.toNamed(AppRoutes.homeScreen);
     }
   }
  }
}
