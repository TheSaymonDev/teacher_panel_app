import 'package:get/get.dart';
import 'package:teacher_panel/screens/profile_update_screen/controllers/upsert_profile_controller.dart';

class ProfileUpdateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UpsertProfileController(),
    );
  }
}
