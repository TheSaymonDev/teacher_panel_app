import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// User Sign In with Email & Password
  Future<Map<String, dynamic>> logIn({
    required String email,
    required String password,
  }) async {
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
        'message': 'Login failed: ${e.toString()}',
      };
    }
  }

  /// Create Class in Firestore
  Future<Map<String, dynamic>> createClass({
    required String className,
    required String numOfStudents,
  }) async {
    try {
      await _firestore.collection("classes").add({
        'className': className,
        'numOfStudents': numOfStudents,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {
        'success': true,
        'message': 'Class created successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create class: ${e.toString()}',
      };
    }
  }

  /// Read Classes from Firestore
  Future<Map<String, dynamic>> readClasses(
      {required String collectionName}) async {
    try {
      final querySnapshot = await _firestore.collection(collectionName).get();
      return {
        'success': true,
        'data': querySnapshot,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to read classes: ${e.toString()}',
      };
    }
  }

  /// Update Class in Firestore
  Future<Map<String, dynamic>> updateClass({
    required String classId,
    required String className,
    required String numOfStudents,
  }) async {
    try {
      await _firestore.collection("classes").doc(classId).update({
        'className': className,
        'numOfStudents': numOfStudents,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return {
        'success': true,
        'message': 'Class updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update class: ${e.toString()}',
      };
    }
  }

  /// Delete Class from Firestore Firebase
  Future<Map<String, dynamic>> deleteClass({required String classId}) async {
    try {
      final batch = _firestore.batch();

      // Step 1: Fetch related subjects
      final subjectsSnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .get();

      for (final subject in subjectsSnapshot.docs) {
        final subjectId = subject.id;

        // Step 2: Fetch related quizzes for each subject
        final quizzesSnapshot = await _firestore
            .collection("classes")
            .doc(classId)
            .collection("subjects")
            .doc(subjectId)
            .collection("quizzes")
            .get();

        for (final quiz in quizzesSnapshot.docs) {
          batch.delete(quiz.reference);
        }

        // Step 3: Delete the subject
        batch.delete(subject.reference);
      }

      // Step 4: Delete the class
      batch.delete(_firestore.collection("classes").doc(classId));

      // Commit the batch
      await batch.commit();

      return {
        'success': true,
        'message': 'Class and all related data deleted successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to delete class: ${e.toString()}',
      };
    }
  }

  /// Create Subject To Firestore
  Future<Map<String, dynamic>> createSubject({
    required String classId,
    required String subjectName,
  }) async {
    try {
      await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .add({
        'subjectName': subjectName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {
        'success': true,
        'message': 'Subject created successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create subject: ${e.toString()}',
      };
    }
  }

  /// Read Subjects From Firestore
  Future<Map<String, dynamic>> readSubjects({required String classId}) async {
    try {
      final querySnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .get();

      return {
        'success': true,
        'data': querySnapshot,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to read subjects: ${e.toString()}',
      };
    }
  }

  /// Update Subject To Firestore
  Future<Map<String, dynamic>> updateSubject({
    required String classId,
    required String subjectId,
    required String subjectName,
  }) async {
    try {
      // Step 1: Update subject
      await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .update({
        'subjectName': subjectName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // ✅ Step 2: Update subjectName in all related quizzes
      final quizCollectionRef = _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .collection("quizzes");

      final quizSnapshot = await quizCollectionRef.get();

      for (var quizDoc in quizSnapshot.docs) {
        await quizDoc.reference.update({
          'subjectName': subjectName,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return {
        'success': true,
        'message': 'Subject and all related quizzes updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update subject and quizzes: ${e.toString()}',
      };
    }
  }


  /// Delete Subject To Firestore
  Future<Map<String, dynamic>> deleteSubject({
    required String classId,
    required String subjectId,
  }) async {
    try {
      final batch = _firestore.batch();

      // Step 1: Fetch related quizzes
      final quizzesSnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId)
          .collection("quizzes")
          .get();

      for (final quiz in quizzesSnapshot.docs) {
        batch.delete(quiz.reference);
      }

      // Step 2: Delete the subject
      batch.delete(
          _firestore.collection("classes").doc(classId).collection("subjects").doc(subjectId));

      // Commit the batch
      await batch.commit();

      return {
        'success': true,
        'message': 'Subject and all related quizzes deleted successfully.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to delete subject: ${e.toString()}',
      };
    }
  }

  /// Create Quiz To Firestore Firebase
  Future<Map<String, dynamic>> createQuiz({
    required String classId,
    required String subjectId,
    required String topicName,
    required String timeDuration, // in minutes
    required String endTime,
    required List<Map<String, dynamic>> questions,
    required String subjectName,
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
        'endTime': endTime,
        'questions': questions,
        'subjectName': subjectName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await quizRef.update({'quizId': quizRef.id});
      return {
        'success': true,
        'message': 'Quiz created successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create quiz: ${e.toString()}',
      };
    }
  }

  /// Read Quizzes From Firestore
  Future<Map<String, dynamic>> readQuizzes({
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
        'data': querySnapshot,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to read quizzes: ${e.toString()}',
      };
    }
  }

  /// Update Quiz To Firestore
  Future<Map<String, dynamic>> updateQuiz({
    required String classId,
    required String subjectId,
    required String quizId,
    required String topicName,
    required int timeDuration,
    required List<Map<String, dynamic>> questions,
    required String subjectName,
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
        'subjectName': subjectName,
      });

      return {
        'success': true,
        'message': 'Quiz updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update quiz: ${e.toString()}',
      };
    }
  }

  /// Delete Quiz From Firestore
  Future<Map<String, dynamic>> deleteQuiz({
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
        'message': 'Quiz deleted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to delete quiz: ${e.toString()}',
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
