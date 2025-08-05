import 'package:get/get.dart';
import 'package:teacher_panel/data/models/subject_model.dart';
import 'package:teacher_panel/data/models/class_model.dart';
import 'package:teacher_panel/screens/subject_details_screen/models/quiz_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class SubjectDetailsController extends GetxController {
  late ClassModel classData;
  late SubjectModel subjectData;
  late String classId;
  late String subjectId;
  bool isLoading = false;
  List<QuizModel> quizzes = [];

  Future<bool> _readQuizzes({
    required String classId,
    required String subjectId,
  }) async {
    _setLoading(true);
    final response = await FirebaseService().readQuizzes(
      classId: classId,
      subjectId: subjectId,
    );
    _setLoading(false);
    if (response['success'] == true) {
      final data = response['data'];
      if (data.docs.isNotEmpty) {
        quizzes = data.docs.map<QuizModel>((doc) {
          return QuizModel.fromFireStore(
            doc.data(),
            doc.id,
          );
        }).toList();
        return true;
      } else {
        quizzes = [];
        AppConstFunctions.customErrorMessage(message: 'No quiz found');
        return false;
      }
    } else {
      AppConstFunctions.customErrorMessage(
          message: response['message'] ?? 'Something went wrong');
      return false;
    }
  }

  Future<bool> deleteQuizById({
    required String classId,
    required String subjectId,
    required String quizId,
  }) async {
    final response = await FirebaseService().deleteQuiz(
      classId: classId,
      subjectId: subjectId,
      quizId: quizId,
    );
    if (response['success'] == true) {
      AppConstFunctions.customSuccessMessage(message: response['message']);
      _readQuizzes(classId: classId, subjectId: subjectId);
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

  void refreshQuizzes() {
    _readQuizzes(classId: classId, subjectId: subjectId);
  }

  @override
  void onInit() {
    super.onInit();
    classData = Get.arguments['classData'] as ClassModel;
    subjectData = Get.arguments['subjectData'] as SubjectModel;
    classId = classData.id!;
    subjectId = subjectData.id!;
    _readQuizzes(classId: classId, subjectId: subjectId);
  }
}
