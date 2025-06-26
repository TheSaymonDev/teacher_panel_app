import 'package:get/get.dart';
import 'package:teacher_panel/screens/class_details_screen/models/subject_model.dart';
import 'package:teacher_panel/screens/home_screen/models/class_model.dart';
import 'package:teacher_panel/services/firebase_service.dart';
import 'package:teacher_panel/utils/app_const_functions.dart';

class ClassDetailsController extends GetxController {
  late ClassModel classData;
  late String classId;
  bool isLoading = false;
  List<SubjectModel> subjects = [];

  Future<bool> _readSubjects({required String classId}) async {
    _setLoading(true);
    final response = await FirebaseService().readSubjects(classId: classId);
    _setLoading(false);
    if (response['success'] == true) {
      final data = response['data'];
      if (data.docs.isNotEmpty) {
        subjects = data.docs.map<SubjectModel>((doc) {
          return SubjectModel.fromFireStore(doc.data(), doc.id);
        }).toList();
        return true;
      } else {
        subjects = [];
        AppConstFunctions.customErrorMessage(message: 'No subject found');
        return false;
      }
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  Future<bool> deleteSubjectById(
      {required String classId, required String subjectId}) async {
    final response = await FirebaseService()
        .deleteSubject(classId: classId, subjectId: subjectId);
    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(
          message: 'Successfully Subject Deleted');
      _readSubjects(classId: classId);
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

  void refreshSubjects() {
    _readSubjects(classId: classId);
  }

  @override
  void onInit() {
    super.onInit();
    classData = Get.arguments['classData'] as ClassModel;
    classId = classData.id!;
    _readSubjects(classId: classId);
  }
}
