import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/models/class_model.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class ReadClassesController extends GetxController {
  bool isLoading = false;
  List<ClassModel> classes = []; // List of ClassModel

  Future<bool> _readClasses() async {
    _setLoading(true);

    final response =
    await FirebaseService().readClasses(collectionName: "classes");

    _setLoading(false);

    if (response['success'] == true) {
      final querySnapshot = response['querySnapshot'];

      // Check if querySnapshot is a QuerySnapshot
      if (querySnapshot.docs.isNotEmpty) {
        // Map the data to ClassModel list
        classes = querySnapshot.docs.map<ClassModel>((doc) {
          return ClassModel.fromFireStore(doc.data(), doc.id);
        }).toList();

        AppConstFunctions.customSuccessMessage(
            message: 'Classes read successful.');
        return true;
      } else {
        AppConstFunctions.customErrorMessage(message: 'No data found.');
        return false;
      }
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong.');
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _readClasses();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
