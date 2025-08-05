import 'package:get/get.dart';
import 'package:teacher_panel/screens/view_reports_screen/controllers/view_reports_controller.dart';

class ViewReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ViewReportsController(),
    );
  }
}
