import 'package:get/get.dart';
import 'package:teacher_panel/data/models/student_info_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class StudentPerformanceController extends GetxController {
  late StudentInfoModel student;
  double averageScore = 0;
  int totalQuizAttempted = 0;
  String bestPerformingSubject = '';
  bool isLoading = false;

  final _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    student = Get.arguments['student'] as StudentInfoModel;
    final classId = Get.arguments['classId'];
    _calculatePerformanceOverview(classId: classId);
  }

  Future<void> _calculatePerformanceOverview({required String classId}) async {
    _setLoading(true);

    final response = await _firebaseService.readQuizResultsForStudent(
      classId: classId,
      userId: student.userId!,
    );

    if (response['success'] != true) {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Failed to load results',
      );
      _setLoading(false);
      return;
    }

    final List results = response['data'];

    if (results.isEmpty) {
      averageScore = 0;
      totalQuizAttempted = 0;
      bestPerformingSubject = 'N/A';
      _setLoading(false);
      return;
    }

    double totalScore = 0;
    Map<String, List<double>> subjectScoreMap = {};

    for (var result in results) {
      final score = (result['scorePercentage'] ?? 0).toDouble();
      final subject = result['subjectName'] ?? 'Unknown';
      totalScore += score;
      subjectScoreMap.putIfAbsent(subject, () => []).add(score);
    }

    totalQuizAttempted = results.length;
    averageScore = totalScore / totalQuizAttempted;

    String bestSubject = 'N/A';
    double bestAvgScore = 0;

    subjectScoreMap.forEach((subject, scores) {
      double avg = scores.reduce((a, b) => a + b) / scores.length;
      if (avg > bestAvgScore) {
        bestAvgScore = avg;
        bestSubject = subject;
      }
    });

    bestPerformingSubject = bestSubject;

    _setLoading(false);
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
