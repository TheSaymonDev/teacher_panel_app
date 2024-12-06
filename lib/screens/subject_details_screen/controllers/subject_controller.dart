import 'package:get/get.dart';

class SubjectDetailsController extends GetxController {
  String subjectName = '';
  bool isLoading = false;

  // Mock Quiz List
  final quizzes = [
    {
      "quizName": "Math Basics Quiz",
      "date": "12 Nov 2024",
      "studentsParticipated": 20,
      "averageScore": "85%",
    },
    {
      "quizName": "Advanced Math Quiz",
      "date": "15 Nov 2024",
      "studentsParticipated": 18,
      "averageScore": "78%",
    },
  ];

  // Method to Update Quizzes (Optional)
  void addQuiz(Map<String, String> newQuiz) {
    quizzes.add(newQuiz);
    update(); // Notify GetBuilder to rebuild
  }

  // Mock Loading (Optional)
  void toggleLoading(bool value) {
    isLoading = value;
    update(); // Notify GetBuilder to rebuild
  }
}
