class QuizReportModel {
  final String quizTitle;
  final DateTime quizDate;
  final double avgScore;
  final int totalParticipants;

  QuizReportModel({
    required this.quizTitle,
    required this.quizDate,
    required this.avgScore,
    required this.totalParticipants,
  });
}
