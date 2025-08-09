import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/data/models/subject_model.dart';
import 'package:teacher_panel/data/models/class_model.dart';
import 'package:teacher_panel/screens/view_reports_screen/models/date_range_model.dart';
import 'package:teacher_panel/screens/view_reports_screen/models/quiz_report_model.dart';
import 'package:teacher_panel/data/services/firebase_service.dart';
import 'package:teacher_panel/core/utils/app_const_functions.dart';

class ViewReportsController extends GetxController {
  // Filters
  late List<ClassModel> classesData;
  String? selectedClass;
  List<SubjectModel> subjectsData = [];
  String? selectedSubject;
  final List<DateRange> dateRanges = [
    DateRange(title: 'Today', value: 'today'),
    DateRange(title: 'Last 7 Days', value: 'last7Days'),
    DateRange(title: 'Last 30 Days', value: 'last30Days'),
    DateRange(title: 'All Time', value: 'allTime'),
  ];
  String? selectedRange;
  final formKey = GlobalKey<FormState>();

  // Reports & State
  bool isLoading = false;
  List<QuizReportModel> reports = [];

  final _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    classesData = Get.arguments['classes'] as List<ClassModel>;
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  // Class Selection & Load Subjects
  Future<void> onClassSelected(String className) async {
    selectedClass = className;
    selectedSubject = null;

    final classId = classesData.firstWhere((cls) => cls.className == className).id;
    final response = await FirebaseService().readSubjects(classId: classId!);

    if (response['success'] == true && response['data'].docs.isNotEmpty) {
      subjectsData = response['data'].docs.map<SubjectModel>((doc) {
        return SubjectModel.fromFireStore(doc.data(), doc.id);
      }).toList();
    } else {
      subjectsData = [];
    }

    update();
  }

  // Subject Selection
  void onSubjectSelected(String subjectName) {
    selectedSubject = subjectName;
    update();
  }

  // Date Range Selection
  void onRangeSelected(String range) {
    selectedRange = range;
    update();
  }

  // Fetch Reports (Based on Filters)
  Future<bool> fetchReports() async {
    _setLoading(true);

    final classId =
        classesData.firstWhere((cls) => cls.className == selectedClass).id!;
    final response = await _firebaseService.readQuizReportData(
      classId: classId,
      subjectName: selectedSubject!,
      filter: selectedRange!,
    );

    _setLoading(false);

    if (response['success'] == true) {
      reports = List<QuizReportModel>.from(response['data']);
      return true;
    } else {
      AppConstFunctions.customErrorMessage(
        message: response['message'] ?? 'Something went wrong',
      );
      return false;
    }
  }
}
