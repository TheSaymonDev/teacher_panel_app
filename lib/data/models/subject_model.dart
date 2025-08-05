import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  String? id;
  String? subjectName;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  SubjectModel(
      {this.id,
        this.subjectName,
        this.createdAt,
        this.updatedAt,
      });

  SubjectModel.fromFireStore(Map<String, dynamic> json, String docId) {
    id = docId;
    subjectName = json['subjectName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subjectName'] = subjectName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

