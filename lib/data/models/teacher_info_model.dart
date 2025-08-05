import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherInfoModel {
  String? id;
  String? fullName;
  String? schoolName;
  String? imageUrl;
  Timestamp? createdAt;

  TeacherInfoModel({
    this.id,
    this.fullName,
    this.schoolName,
    this.imageUrl,
    this.createdAt,
  });

  factory TeacherInfoModel.fromFireStore(Map<String, dynamic> json, String docId) {
    return TeacherInfoModel(
      id: docId,
      fullName: json['fullName'],
      schoolName: json['schoolName'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
    );
  }

  // 👉 static data
  factory TeacherInfoModel.defaultData() {
    return TeacherInfoModel(
      id: null,
      fullName: 'John Doe',
      schoolName: 'Bangladesh Navy School & College',
      imageUrl: null,
      createdAt: null,
    );
  }
}
