import 'package:get/get.dart';
import 'package:teacher_panel/data/models/student_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/screens/student_details_screen/models/student_subject_reports_model.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class StudentSubjectReportsController extends GetxController {
  late StudentModel studentData;
  late String classId;
  List<StudentSubjectReportsModel> subjectReports = [];
  bool isLoading = false;

  final _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    studentData = Get.arguments['student'] as StudentModel;
    classId = studentData.classId ?? '';
    _calculateSubjectReports(classId: classId);
  }

  Future<void> _calculateSubjectReports({required String classId}) async {
    _setLoading(true);

    final resultResponse = await _firebaseService.readQuizResultsForStudent(
      classId: classId,
      userId: studentData.userId!,
    );

    if (resultResponse['success'] != true) {
      AppConstFunctions.customErrorMessage(
        message: resultResponse['message'] ?? 'Failed to load results',
      );
      _setLoading(false);
      return;
    }

    final List results = resultResponse['data'];

    if (results.isEmpty) {
      subjectReports.clear();
      _setLoading(false);
      return;
    }

    final quizResponse = await _firebaseService.readAllQuizzesByClassId(classId: classId);

    if (quizResponse['success'] != true) {
      AppConstFunctions.customErrorMessage(
        message: quizResponse['message'] ?? 'Failed to load quizzes',
      );
      _setLoading(false);
      return;
    }

    final List quizzes = quizResponse['data'];

    final Map<String, int> subjectTotalTopicMap = {};
    for (var quiz in quizzes) {
      final subjectName = quiz['subjectName'] ?? 'Unknown';
      subjectTotalTopicMap[subjectName] = (subjectTotalTopicMap[subjectName] ?? 0) + 1;
    }

    final Map<String, List<double>> subjectScoreMap = {};
    for (var result in results) {
      final subjectName = result['subjectName'] ?? 'Unknown';
      final double score = (result['scorePercentage'] ?? 0).toDouble();
      subjectScoreMap.putIfAbsent(subjectName, () => []).add(score);
    }

    subjectReports.clear();
    subjectScoreMap.forEach((subject, scores) {
      double avgScore = scores.reduce((a, b) => a + b) / scores.length;
      int totalTopics = subjectTotalTopicMap[subject] ?? 0;
      subjectReports.add(StudentSubjectReportsModel(subject, avgScore, totalTopics));
    });

    _setLoading(false);
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
