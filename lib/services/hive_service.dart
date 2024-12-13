import 'package:hive/hive.dart';
import 'package:teacher_panel/utils/question.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  static const String _boxName = 'questionsBox';
  late Box<Question> _questionBox;

  Future<void> init() async {
    _questionBox = await Hive.openBox<Question>(_boxName);
    print('Box "$_boxName" is open: ${_questionBox.isOpen}');
  }

  /// Add a question
  Future<int?> addQuestion(Question question) async {
    try {
      if (!_questionBox.isOpen) {
        return null;
      }
      final responseKey = await _questionBox.add(question);
      return responseKey;
    } catch (error) {
      return null;
    }
  }


  /// Get all questions
  List<Question> getQuestions() {
    return _questionBox.values.toList();
  }

  /// Get question by index
  Question getQuestion(int index) {
    return _questionBox.getAt(index)!;
  }

  /// Update question
  Future<void> updateQuestion(int index, Question updatedQuestion) async {
    await _questionBox.putAt(index, updatedQuestion);
  }

  /// Delete question
  Future<void> deleteQuestion(int index) async {
    await _questionBox.deleteAt(index);
  }

  /// Clear all data
  Future<void> clearAllData() async {
    await _questionBox.clear();
  }

}
