import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/services/connectivity_service.dart';
import 'package:teacher_panel/services/shared_preference_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';


class ConnectionController extends GetxController {
  bool isLoading = false;

  Future<void> checkConnection() async {
    _setLoading(true);
    final bool hasInternet = await ConnectivityService.isConnected();
    if (hasInternet) {
      final token = SharedPreferencesService().getUserId();
      if(token.isNotEmpty){
        Get.offAllNamed(AppRoutes.homeScreen);
      }else{
        Get.offAllNamed(AppRoutes.logInScreen);
      }
      _setLoading(false);
    } else {
      AppConstFunctions.customErrorMessage(
          message: 'Still no internet connection. Please try again.');
      _setLoading(false);
    }
  }
  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
