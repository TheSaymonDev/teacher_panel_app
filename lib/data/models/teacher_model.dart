import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TeacherModel {
  String? id;
  String? fullName;
  String? schoolName;
  String? imageUrl;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  TeacherModel({
    this.id,
    this.fullName,
    this.schoolName,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory TeacherModel.fromFireStore(Map<String, dynamic> json, String docId) {
    return TeacherModel(
      id: docId,
      fullName: json['fullName'],
      schoolName: json['schoolName'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // 👉 static data
  factory TeacherModel.defaultData() {
    return TeacherModel(
      id: null,
      fullName: 'john_doe'.tr,
      schoolName: 'abc_school'.tr,
      imageUrl: null,
      createdAt: null,
    );
  }
}
