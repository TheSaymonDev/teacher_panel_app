import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/data/models/class_model.dart';
import 'package:teacher_panel/data/models/student_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';

class StudentsInfoController extends GetxController {
  late final String classId;
  bool isLoading = false;
  List<StudentModel> studentsData = [];

  final _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    final classData = Get.arguments['classData'] as ClassModel;
    classId = classData.id!;
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
      studentsData = data.docs
          .map<StudentModel>(
            (doc) => StudentModel.fromFireStore(doc.data(), doc.id),
          )
          .toList();
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Something went wrong',
      );
    }

    update();
  }
}
