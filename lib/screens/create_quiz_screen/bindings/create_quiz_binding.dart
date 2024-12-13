import 'package:get/get.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/create_quiz_controller.dart';
import 'package:teacher_panel/screens/create_quiz_screen/controllers/question_controller.dart';

class CreateQuizBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(QuestionController());
    Get.lazyPut(() => CreateQuizController());
  }
}
