import 'package:get/get.dart';
import 'package:teacher_panel/screens/add_class_screen/controllers/add_class_controller.dart';

class AddClassBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AddClassController());
  }
}