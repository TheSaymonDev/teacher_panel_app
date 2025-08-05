import 'package:get/get.dart';
import 'package:teacher_panel/screens/class_reports_analytics_screen/controllers/class_reports_analytics_controller.dart';

class ClassReportsAnalyticsBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ClassReportsAnalyticsController(),);
  }
}