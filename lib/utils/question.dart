import 'package:hive/hive.dart';

part 'question.g.dart'; // To generate Hive TypeAdapter

@HiveType(typeId: 0)
class Question {
  @HiveField(0)
  final String questionText;

  @HiveField(1)
  final List<String> options;

  @HiveField(2)
  final int correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}
