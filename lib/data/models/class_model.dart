import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  String? id;
  String? className;
  String? section;
  String? numOfStudents;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  ClassModel({
    this.id,
    this.className,
    this.section,
    this.numOfStudents,
    this.createdAt,
    this.updatedAt,
  });

  ClassModel.fromFireStore(Map<String, dynamic> json, String docId) {
    id = docId;
    className = json['className'];
    section = json['section'];
    numOfStudents = json['numOfStudents'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
