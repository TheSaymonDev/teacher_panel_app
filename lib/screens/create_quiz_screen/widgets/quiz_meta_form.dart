import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_validators.dart';
import 'package:teacher_panel/core/widgets/custom_text_form_field.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/create_quiz_controller.dart';

class QuizMetaForm extends StatelessWidget {
  const QuizMetaForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateQuizController>();
    return Form(
      key: controller.formKey,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: controller.topicNameController,
                hintText: 'topic_name'.tr,
                validator: AppValidators.requiredValidator,
              ),
              Gap(16.h),
              GetBuilder<CreateQuizController>(
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${'time'.tr}: ${controller.selectedDuration} ${'minutes'.tr}"),
                    Slider(
                      value: controller.selectedDuration.toDouble(),
                      min: 1,
                      max: 60,
                      divisions: 59,
                      inactiveColor:
                      context.isDarkMode ? Colors.white38 : Colors.black12,
                      label: '${controller.selectedDuration} ${'minutes'.tr}',
                      onChanged: (value) =>
                          controller.updateDuration(value.toInt()),
                    ),
                  ],
                ),
              ),
              GetBuilder<CreateQuizController>(
                builder: (_) => CustomTextFormField(
                  controller: controller.endTimeController,
                  hintText: 'select_end_time'.tr,
                  readOnly: true,
                  validator: AppValidators.requiredValidator,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.timelapse),
                    onPressed: () => controller.pickEndDateTime(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
