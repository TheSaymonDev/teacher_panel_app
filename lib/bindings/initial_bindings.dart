import 'package:get/get.dart';
import 'package:teacher_panel/core/controllers/language_controller.dart';
import 'package:teacher_panel/core/controllers/theme_controller.dart';



class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(LanguageController());
  }
}
