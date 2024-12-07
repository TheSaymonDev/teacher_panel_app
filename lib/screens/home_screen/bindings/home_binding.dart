import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/controllers/read_classes_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ReadClassesController());
  }
}
