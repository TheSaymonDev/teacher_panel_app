import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String? id;
  String? topicName;
  String? timeDuration;
  List<Questions>? questions;
  Timestamp? createdAt;

  QuizModel({this.id, this.topicName, this.timeDuration, this.questions, this.createdAt});

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
    return data;
  }
}

class Questions {
  String? questionText;
  List<String>? options;
  String? correctAns;

  Questions({this.questionText, this.options, this.correctAns});

  Questions.fromJson(Map<String, dynamic> json) {
    questionText = json['questionText'];
    options = json['options'].cast<String>();
    correctAns = json['correctAns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionText'] = questionText;
    data['options'] = options;
    data['correctAns'] = correctAns;
    return data;
  }
}
