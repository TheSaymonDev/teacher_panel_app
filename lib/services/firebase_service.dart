import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// User Sign In with Email & Password
  Future<dynamic> logIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {
        'success': true,
        'user': userCredential.user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Fetch Classes From Firestore Firebase
  Future<dynamic> readClasses ({required String collectionName})async{
    try{
      final querySnapshot = await  _firestore
          .collection(collectionName).get();
      return {
        'success': true,
        'querySnapshot': querySnapshot,
      };
    }catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Publish Questions to Firestore
  Future<dynamic> publishQuestions({
    required String topicName,
    required int timeDuration,
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final docRef = await _firestore.collection("generalKnowledge").add({
        'topicName': topicName,
        'timeDuration': timeDuration,
        'questions': questions,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'docId': docRef.id,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<dynamic> createClass({
    required String className,
    String? classCode,
    required String numOfStudents,
    required List<String> subjects,
  }) async {
    try {
      final docRef = await _firestore.collection("classes").add({
        'className': className,
        'classCode': classCode,
        'numOfStudents': numOfStudents,
        'subjects': subjects,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {
        'success': true,
        'docId': docRef.id,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      developer.log("SignOut Error: $e");
    }
  }
}
