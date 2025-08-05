import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/data/models/class_model.dart';
import 'package:teacher_panel/data/models/student_info_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';

class StudentsInfoController extends GetxController {
  late final String classId;
  bool isLoading = false;
  List<StudentInfoModel> studentsInfo = [];

  final _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments['classData'] as ClassModel;
    classId = data.id!;
    _fetchStudentsInfo();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> _fetchStudentsInfo() async {
    _setLoading(true);
    final response =
        await _firebaseService.readUsersByClassId(classId: classId);
    _setLoading(false);

    if (response['success'] == true) {
      final data = response['data'];
      studentsInfo = data.docs
          .map<StudentInfoModel>(
            (doc) => StudentInfoModel.fromFireStore(doc.data(), doc.id),
          )
          .toList();

      if (studentsInfo.isEmpty) {
        AppConstFunctions.customErrorMessage(message: 'No students found');
      }
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Something went wrong',
      );
    }

    update();
  }
}
