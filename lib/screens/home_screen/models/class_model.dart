import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  String? id;
  String? className;
  String? classCode;
  String? numOfStudents;
  List<String>? subjects;
  Timestamp? createdAt;

  ClassModel(
      {this.id,
        this.className,
        this.classCode,
        this.numOfStudents,
        this.subjects,
        this.createdAt});

  ClassModel.fromFireStore(Map<String, dynamic> json, id) {
    id = json['id'];
    className = json['className'];
    classCode = json['classCode'];
    numOfStudents = json['numOfStudents'];
    subjects = json['subjects'].cast<String>();
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['className'] = className;
    data['classCode'] = classCode;
    data['numOfStudents'] = numOfStudents;
    data['subjects'] = subjects;
    data['createdAt'] = createdAt;
    return data;
  }
}

