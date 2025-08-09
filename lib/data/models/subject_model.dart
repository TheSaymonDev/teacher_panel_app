import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  String? id;
  String? subjectName;
  String? className;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  SubjectModel({
    this.id,
    this.subjectName,
    this.className,
    this.createdAt,
    this.updatedAt,
  });

  SubjectModel.fromFireStore(Map<String, dynamic> json, String docId) {
    id = docId;
    subjectName = json['subjectName'];
    className = json['className'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
