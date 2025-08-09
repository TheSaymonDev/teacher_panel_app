import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String? id;
  String? topicName;
  String? subjectName;
  String? className;
  String? timeDuration;
  String? endTime;
  List<Questions>? questions;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  QuizModel({
    this.id,
    this.topicName,
    this.subjectName,
    this.className,
    this.timeDuration,
    this.endTime,
    this.questions,
    this.createdAt,
    this.updatedAt,
  });

  QuizModel.fromFireStore(Map<String, dynamic> json, String docId) {
    id = docId;
    topicName = json['topicName'];
    subjectName = json['subjectName'];
    className = json['className'];
    timeDuration = json['timeDuration'];
    endTime = json['endTime'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class Questions {
  String? questionText;
  List<String>? options;
  int? correctAnswer;

  Questions({
    this.questionText,
    this.options,
    this.correctAnswer,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    questionText = json['questionText'];
    options = json['options'].cast<String>();
    correctAnswer = json['correctAnswer'];
  }
}
