import 'package:get/get.dart';
import 'package:teacher_panel/screens/home_screen/models/class_model.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class ManageClassController extends GetxController {
  bool isLoading = false;
  List<ClassModel> classes = [];

  Future<bool> _readClasses() async {
    _setLoading(true);
    final response =
    await FirebaseService().readClasses(collectionName: "classes");
    _setLoading(false);
    if (response['success'] == true) {
      final querySnapshot = response['querySnapshot'];
      if (querySnapshot.docs.isNotEmpty) {
        classes = querySnapshot.docs.map<ClassModel>((doc) {
          return ClassModel.fromFireStore(doc.data(), doc.id);
        }).toList();
        return true;
      } else {
        classes = [];
        AppConstFunctions.customErrorMessage(message: 'No class found.');
        return false;
      }
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong.');
      return false;
    }
  }

  Future<bool> deleteClassById({required String classId}) async {
    final response = await FirebaseService().deleteClass(classId: classId);
    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(
          message: 'Successfully Class Deleted');
      _readClasses();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void refreshClass(){
    _readClasses();
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
