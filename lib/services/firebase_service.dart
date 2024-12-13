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

  /// Create Class To Firestore Firebase
  Future<dynamic> createClass({
    required String className,
    String? classCode,
    required String numOfStudents
  }) async {
    try {
      final docRef = await _firestore.collection("classes").add({
        'className': className,
        'classCode': classCode,
        'numOfStudents': numOfStudents,
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

  /// Read Classes From Firestore Firebase
  Future<dynamic> readClasses({required String collectionName}) async {
    try {
      final querySnapshot = await _firestore.collection(collectionName).get();
      return {
        'success': true,
        'querySnapshot': querySnapshot,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Update Class in Firestore Firebase
  Future<dynamic> updateClass({
    required String classId,
    required String className,
    String? classCode,
    required String numOfStudents,
  }) async {
    try {
      await _firestore.collection("classes").doc(classId).update({
        'className': className,
        'classCode': classCode,
        'numOfStudents': numOfStudents,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Class updated successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Delete Class from Firestore Firebase
  Future<dynamic> deleteClass({required String classId}) async {
    try {
      await _firestore.collection("classes").doc(classId).delete();
      return {
        'success': true,
        'message': 'Class deleted successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Create Subject To Firestore Firebase
  Future<dynamic> createSubject({
    required String classId,
    required String subjectName,
  }) async {
    try {
      final subjectRef = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .add({
        'subjectName': subjectName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {
        'success': true,
        'subjectId': subjectRef.id,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Read Subjects To Firestore Firebase
  Future<dynamic> readSubjects({required String classId}) async {
    try {
      final querySnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .get();

      return {
        'success': true,
        'querySnapshot': querySnapshot,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Update Subject To Firestore Firebase
  Future<dynamic> updateSubject({
    required String classId,
    required String subjectId,
    required String subjectName,
  }) async {
    try {
      await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .update({
        'subjectName': subjectName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Subject updated successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Delete Subject To Firestore Firebase
  Future<dynamic> deleteSubject({
    required String classId,
    required String subjectId,
  }) async {
    try {
      await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .delete();

      return {
        'success': true,
        'message': 'Subject deleted successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Create Quiz To Firestore Firebase
  Future<dynamic> createQuiz({
    required String classId,
    required String subjectId,
    required String topicName,
    required String timeDuration, // in minutes
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final quizRef = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .collection("quizzes")
          .add({
        'topicName': topicName,
        'timeDuration': timeDuration,
        'questions': questions,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {
        'success': true,
        'quizId': quizRef.id,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Read Quizzes From Firestore Firebase
  Future<dynamic> readQuizzes({
    required String classId,
    required String subjectId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .collection("quizzes")
          .get();

      return {
        'success': true,
        'querySnapshot': querySnapshot,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Update Quiz in Firestore Firebase
  Future<dynamic> updateQuiz({
    required String classId,
    required String subjectId,
    required String quizId,
    required String topicName,
    required int timeDuration,
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .collection("quizzes")
          .doc(quizId)
          .update({
        'topicName': topicName,
        'timeDuration': timeDuration,
        'questions': questions,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Quiz updated successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Delete Quiz From Firestore Firebase
  Future<dynamic> deleteQuiz({
    required String classId,
    required String subjectId,
    required String quizId,
  }) async {
    try {
      await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .collection("quizzes")
          .doc(quizId)
          .delete();

      return {
        'success': true,
        'message': 'Quiz deleted successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }


  /// Publish Questions to Firestore
  Future<dynamic> publishQuestions({
    required String subjectName,
    required String topicName,
    required int timeDuration,
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final docRef = await _firestore.collection(subjectName).add({
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
