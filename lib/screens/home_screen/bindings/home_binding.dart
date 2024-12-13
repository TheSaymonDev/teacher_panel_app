import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/controllers/upsert_class_controller.dart';
import 'package:teacher_panel/screens/home_screen/controllers/manage_class_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ManageClassController());
    Get.put(UpsertClassController());
  }
}
