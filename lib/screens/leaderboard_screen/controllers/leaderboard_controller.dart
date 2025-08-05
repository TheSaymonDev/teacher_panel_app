import 'package:get/get.dart';
import 'package:teacher_panel/screens/leaderboard_screen/models/leaderboard_user_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class LeaderboardController extends GetxController {
  bool isLoading = false;
  List<LeaderboardUserModel> leaderboardUsers = [];
  late String classId;

  Future<bool> fetchLeaderboard(String filter) async {
    _setLoading(true);
    final response = await FirebaseService().readLeaderboardData(
      classId: classId,
      filter: filter,
    );
    _setLoading(false);

    if (response['success'] == true) {
      leaderboardUsers = List<LeaderboardUserModel>.from(response['data']);
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    classId = Get.arguments['classId'] as String;
    fetchLeaderboard('today');
  }
}
