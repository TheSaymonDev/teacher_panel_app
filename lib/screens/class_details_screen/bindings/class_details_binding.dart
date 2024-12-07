import 'package:get/get.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/class_details_controller.dart';

class ClassDetailsBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ClassDetailsController());
  }
}