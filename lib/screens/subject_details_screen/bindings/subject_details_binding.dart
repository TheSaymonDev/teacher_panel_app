import 'package:get/get.dart';
import 'package:teacher_panel/screens/subject_details_screen/controllers/subject_details_controller.dart';

class SubjectDetailsBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SubjectDetailsController());
  }

}