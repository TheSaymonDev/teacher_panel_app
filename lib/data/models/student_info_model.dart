import 'package:cloud_firestore/cloud_firestore.dart';

class StudentInfoModel {
  String? userId;
  String? name;
  String? email;
  String? className;
  String? schoolName;
  String? fcmToken;
  Timestamp? joinedAt;

  StudentInfoModel({
    this.userId,
    this.name,
    this.email,
    this.className,
    this.schoolName,
    this.fcmToken,
    this.joinedAt,
  });

  StudentInfoModel.fromFireStore(Map<String, dynamic> json, String docId) {
    userId = docId; // ফায়ারস্টোর ডকুমেন্ট আইডি
    name = json['name'];
    email = json['email'];
    className = json['className'];
    schoolName = json['schoolName'];
    fcmToken = json['fcmToken'];
    joinedAt = json['joinedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['className'] = className;
    data['schoolName'] = schoolName;
    data['fcmToken'] = fcmToken;
    data['joinedAt'] = joinedAt;
    return data;
  }
}
