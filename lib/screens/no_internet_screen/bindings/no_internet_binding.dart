import 'package:get/get.dart';
import 'package:teacher_panel/screens/no_internet_screen/controllers/connection_controller.dart';

class NoInternetBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ConnectionController());
  }
}