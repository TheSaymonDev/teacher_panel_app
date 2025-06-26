import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String? id;
  String? topicName;
  String? timeDuration;
  List<Questions>? questions;
  Timestamp? createdAt;
  String? subjectName;

  QuizModel({this.id, this.topicName, this.timeDuration, this.questions, this.createdAt, this.subjectName});

  QuizModel.fromFireStore(Map<String, dynamic> json, String docId) {
    id = docId;
    topicName = json['topicName'];
    timeDuration = json['timeDuration'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    subjectName = json['subjectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['topicName'] = topicName;
    data['timeDuration'] = timeDuration;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['subjectName'] = subjectName;
    return data;
  }
}

class Questions {
  String? questionText;
  List<String>? options;
  int? correctAnswer;

  Questions({this.questionText, this.options, this.correctAnswer});

  Questions.fromJson(Map<String, dynamic> json) {
    questionText = json['questionText'];
    options = json['options'].cast<String>();
    correctAnswer = json['correctAnswer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionText'] = questionText;
    data['options'] = options;
    data['correctAnswer'] = correctAnswer;
    return data;
  }
}
