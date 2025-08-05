import 'package:get/get.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/data/models/subject_model.dart';
import 'package:teacher_panel/data/models/class_model.dart';
import 'package:teacher_panel/screens/class_details_screen/controllers/students_info_controller.dart';

class ClassDetailsController extends GetxController {
  late final ClassModel classData;
  late final String classId;

  bool isLoading = false;
  List<SubjectModel> subjects = [];

  double avgPerformance = 0;
  double avgParticipants = 0;

  final _firebaseService = FirebaseService();
  final  _studentsInfoController = Get.find<StudentsInfoController>();

  @override
  void onInit() {
    super.onInit();
    classData = Get.arguments['classData'] as ClassModel;
    classId = classData.id!;
    _loadInitialData();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void _loadInitialData() async {
    await _readSubjects();
    calculateClassPerformance();
  }

  Future<void> calculateClassPerformance() async {
    final response = await _firebaseService.readAllQuizResultsForClass(classId);

    if (response['success'] == true) {
      final List results = response['data'];

      if (results.isEmpty) {
        avgPerformance = 0;
        avgParticipants = 0;
      } else {
        double totalScore = 0;
        Set<String> participants = {};

        for (var result in results) {
          totalScore += (result['score'] ?? 0);
          participants.add(result['userId']);
        }

        avgPerformance = totalScore / results.length;
        avgParticipants = (participants.length / _studentsInfoController.studentsInfo.length) * 100;
      }
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Failed to calculate performance',
      );
    }

    update();
  }

  Future<void> _readSubjects() async {
    _setLoading(true);
    final response = await _firebaseService.readSubjects(classId: classId);
    _setLoading(false);

    if (response['success'] == true) {
      final data = response['data'];
      subjects = data.docs.map<SubjectModel>(
            (doc) => SubjectModel.fromFireStore(doc.data(), doc.id),
      ).toList();

      if (subjects.isEmpty) {
        AppConstFunctions.customErrorMessage(message: 'No subjects found');
      }
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Something went wrong',
      );
    }
  }


  Future<bool> deleteSubjectById({
    required String classId,
    required String subjectId,
  }) async {
    final response = await _firebaseService.deleteSubject(
      classId: classId,
      subjectId: subjectId,
    );

    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(
        message: 'Subject successfully deleted',
      );
      refreshSubjects();
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Something went wrong',
      );
      return false;
    }
  }

  void refreshSubjects() {
    _readSubjects();
  }
}
