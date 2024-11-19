class QuestionPublishModel {
  String? topicName;
  int? timeDuration;
  List<Questions>? questions;

  QuestionPublishModel({this.topicName, this.timeDuration, this.questions});

  QuestionPublishModel.fromJson(Map<String, dynamic> json) {
    topicName = json['topicName'];
    timeDuration = json['timeDuration'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topicName'] = topicName;
    data['timeDuration'] = timeDuration;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
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
