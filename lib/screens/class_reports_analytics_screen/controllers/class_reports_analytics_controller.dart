import 'package:get/get.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/screens/class_reports_analytics_screen/models/subject_wised_performance_model.dart';
import 'package:teacher_panel/screens/subject_details_screen/models/quiz_model.dart';

class ClassReportsAnalyticsController extends GetxController {
  late String className;
  double avgPerformance = 0;
  double avgParticipants = 0;
  int totalQuizzes = 0;
  int totalQuizzesTaken = 0;
  bool isLoading = false;

  List<QuizModel> quizzes = [];
  List<SubjectWisedPerformanceModel> subjectWisedData = [];

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    className = Get.arguments['className'] as String;
    final classId = Get.arguments['classId'] as String;

    _calculateOverallPerformance(classId: classId);
    _calculateSubjectWisedPerformance(classId: classId);
  }

  Future<void> _calculateOverallPerformance({required String classId}) async {
    final quizResponse =
        await _firebaseService.readAllQuizzesByClassId(classId: classId);
    if (quizResponse['success'] != true) {
      AppConstFunctions.customErrorMessage(
        message: quizResponse['message'] ?? 'Failed to load quizzes',
      );
      update();
      return;
    }

    final quizList = quizResponse['data'];
    totalQuizzes = quizList.length;

    final resultResponse =
        await _firebaseService.readAllQuizResultsForClass(classId);
    if (resultResponse['success'] != true) {
      AppConstFunctions.customErrorMessage(
        message: resultResponse['message'] ?? 'Failed to load results',
      );
      update();
      return;
    }

    final results = resultResponse['data'];
    if (results.isEmpty) {
      avgPerformance = 0;
      avgParticipants = 0;
      totalQuizzesTaken = 0;
    } else {
      double totalScore = 0;
      Set<String> participants = {};
      Set<String> attemptedQuizzes = {};

      for (final result in results) {
        totalScore += (result['score'] ?? 0);
        participants.add(result['userId']);
        attemptedQuizzes.add(result['quizId']);
      }

      avgPerformance = totalScore / results.length;
      avgParticipants = participants.length.toDouble();
      totalQuizzesTaken = attemptedQuizzes.length;
    }

    update();
  }

  Future<void> _calculateSubjectWisedPerformance(
      {required String classId}) async {
    _setLoading(true);
    subjectWisedData.clear();

    final subjectResponse =
        await _firebaseService.readSubjects(classId: classId);
    if (subjectResponse['success'] != true) {
      AppConstFunctions.customErrorMessage(
        message: subjectResponse['message'] ?? 'Failed to load subjects',
      );
      _setLoading(false);
      return;
    }

    final subjectDocs = subjectResponse['data'].docs;
    if (subjectDocs.isEmpty) {
      AppConstFunctions.customErrorMessage(message: 'No subject found');
      _setLoading(false);
      return;
    }

    // 🔁 Fetch all quiz results once
    final resultResponse =
        await _firebaseService.readAllQuizResultsForClass(classId);
    final allResults =
        (resultResponse['success'] == true) ? resultResponse['data'] : [];

    for (final subjectDoc in subjectDocs) {
      final subjectData = subjectDoc.data();
      final subjectId = subjectDoc.id;
      final subjectName = subjectData['subjectName'] ?? 'Unknown';

      final quizResponse = await _firebaseService.readQuizzes(
        classId: classId,
        subjectId: subjectId,
      );

      if (quizResponse['success'] != true) {
        subjectWisedData.add(
          SubjectWisedPerformanceModel(subjectName, 0.0, 0, 0),
        );
        continue;
      }

      final quizDocs = quizResponse['data'].docs;
      final quizIds = quizDocs.map((q) => q.id).toSet();
      final totalQuizzes = quizIds.length;

      if (totalQuizzes == 0) {
        subjectWisedData.add(
          SubjectWisedPerformanceModel(subjectName, 0.0, 0, 0),
        );
        continue;
      }

      double totalScore = 0;
      int count = 0;
      Set<String> attemptedQuizzes = {};

      for (final result in allResults) {
        if (quizIds.contains(result['quizId'])) {
          totalScore += (result['score'] ?? 0);
          attemptedQuizzes.add(result['quizId']);
          count++;
        }
      }

      final avgScore = (count > 0) ? totalScore / count : 0.0;
      subjectWisedData.add(
        SubjectWisedPerformanceModel(
          subjectName,
          avgScore,
          totalQuizzes,
          attemptedQuizzes.length,
        ),
      );
    }

    _setLoading(false);
    update();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }
}
