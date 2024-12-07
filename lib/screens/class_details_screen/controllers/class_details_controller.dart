import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/models/class_model.dart';

class ClassDetailsController extends GetxController{
  late ClassModel classData;
  @override
  void onInit() {
    super.onInit();
    classData = Get.arguments['classData'] as ClassModel;
  }
}