import 'package:get/get.dart';
import 'package:teacher_panel/screens/question_screen/controllers/question_controller.dart';

class QuestionBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(QuestionController());
  }
}