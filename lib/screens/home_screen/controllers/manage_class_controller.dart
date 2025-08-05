import 'package:get/get.dart';
import 'package:teacher_panel/data/models/class_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class ManageClassController extends GetxController {
  bool isLoading = false;
  List<ClassModel> classes = [];

  int totalClasses = 0;
  int totalSubjects = 0;
  int totalStudents = 0;

  final _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    _setLoading(true);

    final classResponse = await _firebaseService.readClasses();

    if (classResponse['success'] == true) {
      final classDocs = classResponse['data'].docs;

      totalClasses = classDocs.length;
      totalSubjects = 0;
      totalStudents = 0;
      classes = [];

      for (final doc in classDocs) {
        final classModel = ClassModel.fromFireStore(doc.data(), doc.id);
        classes.add(classModel);

        // Count students
        final studentCount =
            int.tryParse(classModel.numOfStudents ?? '0') ?? 0;
        totalStudents += studentCount;

        // Read subjects using service
        final subjectResponse =
        await _firebaseService.readSubjects(classId: doc.id);

        if (subjectResponse['success'] == true) {
          totalSubjects += subjectResponse['data'].docs.length as int;
        } else {
          AppConstFunctions.customErrorMessage(
              message: subjectResponse['message']);
        }
      }
    } else {
      AppConstFunctions.customErrorMessage(
          message: classResponse['message'] ?? 'Failed to fetch classes');
    }

    _setLoading(false);
  }

  Future<bool> deleteClassById({required String classId}) async {
    final response = await _firebaseService.deleteClass(classId: classId);

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      await _fetchDashboardData();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  void refreshClass() {
    _fetchDashboardData();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
