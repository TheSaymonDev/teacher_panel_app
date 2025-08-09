import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';
import 'package:teacher_panel/core/utils/app_logger.dart';
import 'package:teacher_panel/screens/leaderboard_screen/models/leaderboard_user_model.dart';
import 'package:teacher_panel/screens/view_reports_screen/models/quiz_report_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ------------------------- AUTHENTICATION METHODS ------------------------- ///

  /// Authenticates user with email and password
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
    } on FirebaseAuthException catch (e) {
      AppLogger.logError('Login failed: ${e.code}');
      return {
        'success': false,
        'message': _getAuthErrorMessage(e.code),
      };
    } catch (e) {
      AppLogger.logError('Unexpected login error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  /// Returns the currently authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      AppLogger.logInfo('User signed out successfully');
    } catch (e) {
      AppLogger.logError('Sign out failed: $e');
    }
  }

  /// ------------------------- CLASS MANAGEMENT METHODS ------------------------- ///

  /// Creates a new class in Firestore
  Future<Map<String, dynamic>> createClass({
    required String className,
    required String section,
    required String numOfStudents,
  }) async {
    try {
      final classRef = await _firestore.collection("classes").add({
        'className': className,
        'section': section,
        'numOfStudents': numOfStudents,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await classRef.update({'classId': classRef.id});
      AppLogger.logInfo('Class created with ID: ${classRef.id}');
      return {
        'success': true,
        'message': 'Class created successfully',
      };
    } catch (e) {
      AppLogger.logError('Class creation failed: $e');
      return {
        'success': false,
        'message': 'Failed to create class: ${e.toString()}',
      };
    }
  }

  /// Fetches all classes from Firestore
  Future<Map<String, dynamic>> readClasses() async {
    try {
      final querySnapshot = await _firestore.collection("classes").get();
      AppLogger.logInfo('Fetched ${querySnapshot.docs.length} classes');

      return {
        'success': true,
        'data': querySnapshot,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch classes: $e');
      return {
        'success': false,
        'message': 'Failed to read classes: ${e.toString()}',
      };
    }
  }

  /// Updates an existing class
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

      AppLogger.logInfo('Class $classId updated successfully');
      return {
        'success': true,
        'message': 'Class updated successfully',
      };
    } catch (e) {
      AppLogger.logError('Class update failed: $e');
      return {
        'success': false,
        'message': 'Failed to update class: ${e.toString()}',
      };
    }
  }

  /// Deletes a class and all its related data (subjects, quizzes)
  Future<Map<String, dynamic>> deleteClass({
    required String classId,
  }) async {
    try {
      final batch = _firestore.batch();

      // Delete all subjects and their quizzes
      final subjectsSnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .get();

      for (final subject in subjectsSnapshot.docs) {
        final quizzesSnapshot =
            await subject.reference.collection("quizzes").get();
        for (final quiz in quizzesSnapshot.docs) {
          batch.delete(quiz.reference);
        }
        batch.delete(subject.reference);
      }

      // Delete the class document
      batch.delete(_firestore.collection("classes").doc(classId));
      await batch.commit();

      AppLogger.logInfo(
          'Class $classId and all related data deleted successfully');
      return {
        'success': true,
        'message': 'Class and all related data deleted successfully.',
      };
    } catch (e) {
      AppLogger.logError('Class deletion failed: $e');
      return {
        'success': false,
        'message': 'Failed to delete class: ${e.toString()}',
      };
    }
  }

  /// ------------------------- SUBJECT MANAGEMENT METHODS ------------------------- ///

  /// Creates a new subject under a class
  Future<Map<String, dynamic>> createSubject({
    required String classId,
    required String subjectName,
    required String className,
  }) async {
    try {
      final subjectRef = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .add({
        'subjectName': subjectName,
        'className': className,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await subjectRef.update({'subjectId': subjectRef.id});
      AppLogger.logInfo('Subject created with ID: ${subjectRef.id}');
      return {
        'success': true,
        'message': 'Subject created successfully',
        'docId': subjectRef.id,
      };
    } catch (e) {
      AppLogger.logError('Subject creation failed: $e');
      return {
        'success': false,
        'message': 'Failed to create subject: ${e.toString()}',
      };
    }
  }

  /// Fetches all subjects for a specific class
  Future<Map<String, dynamic>> readSubjects({
    required String classId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .get();

      AppLogger.logInfo(
          'Fetched ${querySnapshot.docs.length} subjects for class $classId');
      return {
        'success': true,
        'data': querySnapshot,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch subjects: $e');
      return {
        'success': false,
        'message': 'Failed to read subjects: ${e.toString()}',
      };
    }
  }

  /// Updates a subject and all related quizzes
  Future<Map<String, dynamic>> updateSubject({
    required String classId,
    required String subjectId,
    required String subjectName,
  }) async {
    try {
      final batch = _firestore.batch();

      // Update subject document
      final subjectRef = _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId);

      batch.update(subjectRef, {
        'subjectName': subjectName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update all quizzes under this subject
      final quizzesSnapshot = await subjectRef.collection("quizzes").get();
      for (final quiz in quizzesSnapshot.docs) {
        batch.update(quiz.reference, {
          'subjectName': subjectName,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      AppLogger.logInfo(
          'Subject $subjectId and related quizzes updated successfully');

      return {
        'success': true,
        'message': 'Subject and all related quizzes updated successfully',
      };
    } catch (e) {
      AppLogger.logError('Subject update failed: $e');
      return {
        'success': false,
        'message': 'Failed to update subject and quizzes: ${e.toString()}',
      };
    }
  }

  /// Deletes a subject and all its quizzes
  Future<Map<String, dynamic>> deleteSubject({
    required String classId,
    required String subjectId,
  }) async {
    try {
      final batch = _firestore.batch();
      final subjectRef = _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .doc(subjectId);

      // Delete all quizzes under this subject
      final quizzesSnapshot = await subjectRef.collection("quizzes").get();
      for (final quiz in quizzesSnapshot.docs) {
        batch.delete(quiz.reference);
      }

      // Delete the subject
      batch.delete(subjectRef);
      await batch.commit();

      AppLogger.logInfo(
          'Subject $subjectId and all quizzes deleted successfully');
      return {
        'success': true,
        'message': 'Subject and all related quizzes deleted successfully.',
      };
    } catch (e) {
      AppLogger.logError('Subject deletion failed: $e');
      return {
        'success': false,
        'message': 'Failed to delete subject: ${e.toString()}',
      };
    }
  }

  /// ------------------------- QUIZ MANAGEMENT METHODS ------------------------- ///

  /// Creates a new quiz under a subject
  Future<Map<String, dynamic>> createQuiz({
    required String classId,
    required String subjectId,
    required String topicName,
    required String subjectName,
    required String className,
    required String timeDuration, // in minutes
    required String endTime,
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
        'subjectName': subjectName,
        'className': className,
        'timeDuration': timeDuration,
        'endTime': endTime,
        'questions': questions,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await quizRef.update({'quizId': quizRef.id});
      AppLogger.logInfo('Quiz created with ID: ${quizRef.id}');
      return {
        'success': true,
        'message': 'Quiz created successfully',
      };
    } catch (e) {
      AppLogger.logError('Quiz creation failed: $e');
      return {
        'success': false,
        'message': 'Failed to create quiz: ${e.toString()}',
      };
    }
  }

  /// Fetches all quizzes for a specific subject
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
      AppLogger.logInfo(
          'Fetched ${querySnapshot.docs.length} quizzes for subject $subjectId');

      return {
        'success': true,
        'data': querySnapshot,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch quizzes: $e');
      return {
        'success': false,
        'message': 'Failed to read quizzes: ${e.toString()}',
      };
    }
  }

  /// Updates an existing quiz
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
        'subjectName': subjectName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.logInfo('Quiz $quizId updated successfully');
      return {
        'success': true,
        'message': 'Quiz updated successfully',
      };
    } catch (e) {
      AppLogger.logError('Quiz update failed: $e');
      return {
        'success': false,
        'message': 'Failed to update quiz: ${e.toString()}',
      };
    }
  }

  /// Deletes a quiz
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
      AppLogger.logInfo('Quiz $quizId deleted successfully');
      return {
        'success': true,
        'message': 'Quiz deleted successfully',
      };
    } catch (e) {
      AppLogger.logError('Quiz deletion failed: $e');
      return {
        'success': false,
        'message': 'Failed to delete quiz: ${e.toString()}',
      };
    }
  }

  /// Fetches all quizzes for a class (across all subjects)
  Future<Map<String, dynamic>> readAllQuizzesByClassId({
    required String classId,
  }) async {
    try {
      final List<Map<String, dynamic>> allQuizzes = [];

      // Step 1: Fetch all subjects under the class
      final subjectSnapshot = await _firestore
          .collection("classes")
          .doc(classId)
          .collection("subjects")
          .get();

      for (var subjectDoc in subjectSnapshot.docs) {
        final subjectId = subjectDoc.id;

        // Step 2: Fetch all quizzes under this subject
        final quizSnapshot = await _firestore
            .collection("classes")
            .doc(classId)
            .collection("subjects")
            .doc(subjectId)
            .collection("quizzes")
            .get();

        for (var quizDoc in quizSnapshot.docs) {
          final quizData = quizDoc.data();
          quizData['quizId'] = quizDoc.id;
          quizData['subjectId'] = subjectId;
          allQuizzes.add(quizData);
        }
      }
      AppLogger.logInfo(
          'Fetched ${allQuizzes.length} quizzes across all subjects for class $classId');
      return {
        'success': true,
        'data': allQuizzes,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch all quizzes: $e');
      return {
        'success': false,
        'message': 'Failed to read quizzes: ${e.toString()}',
      };
    }
  }

  /// ------------------------- REPORT & ANALYTICS METHODS ------------------------- ///

  /// Generates quiz report data for a specific subject with time filtering
  Future<Map<String, dynamic>> readQuizReportData({
    required String classId,
    required String subjectName,
    required String filter, // today, last7Days, last30Days, allTime
  }) async {
    try {
      AppLogger.logInfo(
          'Generating report for $subjectName with filter: $filter');

      final usersSnapshot = await _firestore
          .collection('classes')
          .doc(classId)
          .collection('users')
          .get();

      AppLogger.logInfo('👥 Total users: ${usersSnapshot.docs.length}');

      DateTime now = DateTime.now();
      DateTime startDate;

      switch (filter) {
        case 'today':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'last7Days':
          startDate = now.subtract(Duration(days: 7));
          break;
        case 'last30Days':
          startDate = now.subtract(Duration(days: 30));
          break;
        default:
          startDate = DateTime(2000);
      }

      Map<String, List<double>> quizScoreMap = {};
      Map<String, int> quizParticipantMap = {};

      for (final userDoc in usersSnapshot.docs) {
        final resultsSnapshot = await userDoc.reference
            .collection('results')
            .where('subjectName', isEqualTo: subjectName)
            .where('attemptedAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .get();

        for (final result in resultsSnapshot.docs) {
          final data = result.data();
          final quizTitle = data['topicName'] ?? 'Unnamed Quiz';
          final score = (data['scorePercentage'] ?? 0).toDouble();

          quizScoreMap.putIfAbsent(quizTitle, () => []);
          quizScoreMap[quizTitle]!.add(score);

          quizParticipantMap[quizTitle] =
              (quizParticipantMap[quizTitle] ?? 0) + 1;
        }
      }

      List<QuizReportModel> reports = quizScoreMap.entries.map((entry) {
        final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
        return QuizReportModel(
          quizTitle: entry.key,
          avgScore: avg,
          totalParticipants: quizParticipantMap[entry.key] ?? 0,
          quizDate: DateTime.now(), // Optional
        );
      }).toList();
      AppLogger.logInfo('Generated report with ${reports.length} quiz entries');
      return {
        'success': true,
        'data': reports,
      };
    } catch (e) {
      AppLogger.logError('Report generation failed: $e');
      return {
        'success': false,
        'message': 'Failed to fetch reports: ${e.toString()}',
      };
    }
  }

  /// ------------------------- USER MANAGEMENT METHODS ------------------------- ///

  /// Fetches all users in a class
  Future<Map<String, dynamic>> readUsersByClassId({
    required String classId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('classes')
          .doc(classId)
          .collection('users')
          .get();
      AppLogger.logInfo(
          'Fetched ${querySnapshot.docs.length} users for class $classId');
      return {
        'success': true,
        'data': querySnapshot,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch users: $e');
      return {
        'success': false,
        'message': 'Failed to read users: ${e.toString()}',
      };
    }
  }

  /// Fetches all quiz results for all users in a class
  Future<Map<String, dynamic>> readAllQuizResultsForClass(
    String classId,
  ) async {
    try {
      final classRef = _firestore.collection('classes').doc(classId);
      final userSnapshot = await classRef.collection('users').get();

      List<Map<String, dynamic>> allResults = [];

      for (var userDoc in userSnapshot.docs) {
        final userId = userDoc.id;
        final resultsSnapshot = await classRef
            .collection('users')
            .doc(userId)
            .collection('results')
            .get();

        for (var resultDoc in resultsSnapshot.docs) {
          final resultData = resultDoc.data();
          resultData['userId'] = userId;
          resultData['resultId'] = resultDoc.id;
          allResults.add(resultData);
        }
      }
      AppLogger.logInfo(
          'Fetched ${allResults.length} results for class $classId');
      return {
        'success': true,
        'data': allResults,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch quiz results: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Fetches quiz results for a specific student
  Future<Map<String, dynamic>> readQuizResultsForStudent({
    required String classId,
    required String userId,
  }) async {
    try {
      final resultSnapshot = await _firestore
          .collection('classes')
          .doc(classId)
          .collection('users')
          .doc(userId)
          .collection('results')
          .get();

      final List<Map<String, dynamic>> results = resultSnapshot.docs.map((doc) {
        final data = doc.data();
        data['resultId'] = doc.id;
        return data;
      }).toList();
      AppLogger.logInfo('Fetched ${results.length} results for user $userId');
      return {
        'success': true,
        'data': results,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch student results: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// ------------------------- LEADERBOARD METHODS ------------------------- ///

  /// Generates leaderboard data with time filtering
  Future<Map<String, dynamic>> readLeaderboardData({
    required String classId,
    required String filter,
  }) async {
    try {
      AppLogger.logInfo(
          'Generating leaderboard for class $classId with filter: $filter');

      final usersSnapshot = await _firestore
          .collection('classes')
          .doc(classId)
          .collection('users')
          .get();

      AppLogger.logInfo('Total users found: ${usersSnapshot.docs.length}');

      DateTime now = DateTime.now();
      DateTime startDate;

      if (filter == 'today') {
        startDate = DateTime(now.year, now.month, now.day);
      } else if (filter == 'week') {
        startDate = now.subtract(Duration(days: now.weekday - 1));
      } else if (filter == 'month') {
        startDate = DateTime(now.year, now.month, 1);
      } else {
        startDate = DateTime(2000);
      }

      AppLogger.logDebug('Start date for filter "$filter": $startDate');

      List<LeaderboardUserModel> leaderboard = [];

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final username = userDoc.data()['name'] ?? 'Unknown';
        final imageUrl = userDoc.data()['imageUrl'] ?? '';

        AppLogger.logDebug('Processing user: $username ($userId)');

        final resultsSnapshot = await _firestore
            .collection('classes')
            .doc(classId)
            .collection('users')
            .doc(userId)
            .collection('results')
            .where('attemptedAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .get();

        AppLogger.logDebug('  → Results found: ${resultsSnapshot.docs.length}');

        double totalScore = 0;
        for (final doc in resultsSnapshot.docs) {
          final score = (doc.data()['correctAnswers'] ?? 0).toDouble();
          AppLogger.logDebug('    → Score: $score');
          totalScore += score;
        }

        leaderboard.add(LeaderboardUserModel(
          userId: userId,
          username: username,
          imageUrl: imageUrl,
          totalScore: totalScore.toInt(),
        ));
      }

      leaderboard.sort((a, b) => b.totalScore.compareTo(a.totalScore));
      AppLogger.logInfo(
          'Generated leaderboard with ${leaderboard.length} entries');

      return {
        'success': true,
        'data': leaderboard,
      };
    } catch (e) {
      AppLogger.logError('Leaderboard generation failed: $e');
      return {
        'success': false,
        'message': 'Failed to fetch leaderboard: ${e.toString()}'
      };
    }
  }

  /// ------------------------- TEACHER PROFILE METHODS ------------------------- ///

  /// Creates teacher profile information
  Future<Map<String, dynamic>> createTeacherInfo({
    required String fullName,
    required String schoolName,
    required File? profileImage,
  }) async {
    try {
      String base64Image = '';

      if (profileImage != null) {
        base64Image =
            await AppConstFunctions.convertImageToBase64(profileImage);
      }

      await _firestore.collection('teacherInfo').add({
        'fullName': fullName,
        'schoolName': schoolName,
        'imageUrl': base64Image,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.logInfo('Teacher profile created successfully');
      return {
        'success': true,
        'message': 'Teacher info successfully created.',
      };
    } catch (e) {
      AppLogger.logError('Teacher profile creation failed: $e');
      return {
        'success': false,
        'message': 'Failed to create teacher info: ${e.toString()}',
      };
    }
  }

  /// Fetches all teacher profiles
  Future<Map<String, dynamic>> readTeacherInfo() async {
    try {
      final querySnapshot = await _firestore.collection("teacherInfo").get();
      AppLogger.logInfo(
          'Fetched ${querySnapshot.docs.length} teacher profiles');
      return {
        'success': true,
        'data': querySnapshot,
      };
    } catch (e) {
      AppLogger.logError('Failed to fetch teacher profiles: $e');
      return {
        'success': false,
        'message': 'Failed to read teacher info: ${e.toString()}',
      };
    }
  }

  /// Updates teacher profile information
  Future<Map<String, dynamic>> updateTeacherInfo({
    required String docId,
    required String fullName,
    required String schoolName,
    required File? profileImage,
  }) async {
    try {
      String base64Image = '';

      if (profileImage != null) {
        base64Image =
            await AppConstFunctions.convertImageToBase64(profileImage);
      }

      final Map<String, dynamic> updatedData = {
        'fullName': fullName,
        'schoolName': schoolName,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Only add imageUrl if new image is provided
      if (base64Image.isNotEmpty) {
        updatedData['imageUrl'] = base64Image;
      }

      await _firestore
          .collection('teachersInfo')
          .doc(docId)
          .update(updatedData);
      AppLogger.logInfo('Teacher profile $docId updated successfully');
      return {
        'success': true,
        'message': 'Teacher info successfully updated.',
      };
    } catch (e) {
      AppLogger.logError('Teacher profile update failed: $e');
      return {
        'success': false,
        'message': 'Failed to update teacher info: ${e.toString()}',
      };
    }
  }

  /// Returns user-friendly auth error messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'operation-not-allowed':
        return 'Email/password login is not enabled';
      default:
        return 'Login failed. Please try again';
    }
  }
}
