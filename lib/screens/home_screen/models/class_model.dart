import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  String? id;
  String? className;
  String? classCode;
  String? numOfStudents;
  Timestamp? createdAt;

  ClassModel(
      {this.id,
        this.className,
        this.classCode,
        this.numOfStudents,
        this.createdAt});

  ClassModel.fromFireStore(Map<String, dynamic> json, String docId) {
    id = docId;
    className = json['className'];
    classCode = json['classCode'];
    numOfStudents = json['numOfStudents'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['className'] = className;
    data['classCode'] = classCode;
    data['numOfStudents'] = numOfStudents;
    data['createdAt'] = createdAt;
    return data;
  }
}

