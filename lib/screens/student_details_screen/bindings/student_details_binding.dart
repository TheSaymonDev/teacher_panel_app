import 'package:get/get.dart';
import 'package:teacher_panel/screens/student_details_screen/controllers/student_performance_controller.dart';
import 'package:teacher_panel/screens/student_details_screen/controllers/student_subject_reports_controller.dart';

class StudentDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => StudentPerformanceController(),
    );
    Get.lazyPut(
      () => StudentSubjectReportsController(),
    );
  }
}
