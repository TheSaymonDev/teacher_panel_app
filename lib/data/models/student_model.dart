import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String? userId;
  String? classId;
  String? studentName;
  String? email;
  String? className;
  String? schoolName;
  String? imageUrl;
  String? fcmToken;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  StudentModel({
    this.userId,
    this.classId,
    this.studentName,
    this.email,
    this.className,
    this.schoolName,
    this.imageUrl,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  StudentModel.fromFireStore(Map<String, dynamic> json, String docId) {
    userId = docId; // ফায়ারস্টোর ডকুমেন্ট আইডি
    classId = json['classId'];
    studentName = json['studentName'];
    email = json['email'];
    className = json['className'];
    schoolName = json['schoolName'];
    imageUrl = json['imageUrl'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
