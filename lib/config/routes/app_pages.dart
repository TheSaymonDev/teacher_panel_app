import 'package:get/get.dart';
import 'package:teacher_panel/config/routes/app_routes.dart';
import 'package:teacher_panel/screens/class_details_screen/bindings/class_details_binding.dart';
import 'package:teacher_panel/screens/class_details_screen/class_details_screen.dart';
import 'package:teacher_panel/screens/class_reports_analytics_screen/bindings/class_reports_analytics_binding.dart';
import 'package:teacher_panel/screens/class_reports_analytics_screen/class_reports_analytics_screen.dart';
import 'package:teacher_panel/screens/create_quiz_screen/bindings/create_quiz_binding.dart';
import 'package:teacher_panel/screens/create_quiz_screen/create_quiz_screen.dart';
import 'package:teacher_panel/screens/home_screen/bindings/home_binding.dart';
import 'package:teacher_panel/screens/home_screen/home_screen.dart';
import 'package:teacher_panel/screens/leaderboard_screen/bindings/leaderboard_binding.dart';
import 'package:teacher_panel/screens/leaderboard_screen/leaderboard_screen.dart';
import 'package:teacher_panel/screens/log_in_screen/bindings/log_in_binding.dart';
import 'package:teacher_panel/screens/log_in_screen/log_in_screen.dart';
import 'package:teacher_panel/screens/no_internet_screen/bindings/no_internet_binding.dart';
import 'package:teacher_panel/screens/no_internet_screen/no_internet_screen.dart';
import 'package:teacher_panel/screens/profile_update_screen/bindings/profile_update_binding.dart';
import 'package:teacher_panel/screens/profile_update_screen/profile_update_screen.dart';
import 'package:teacher_panel/screens/student_details_screen/bindings/student_details_binding.dart';
import 'package:teacher_panel/screens/student_details_screen/student_details_screen.dart';
import 'package:teacher_panel/screens/subject_details_screen/bindings/subject_details_binding.dart';
import 'package:teacher_panel/screens/subject_details_screen/subject_details_screen.dart';
import 'package:teacher_panel/screens/view_reports_screen/bindings/view_report_binding.dart';
import 'package:teacher_panel/screens/view_reports_screen/view_reports_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.noInternetScreen,
      page: () => NoInternetScreen(),
      binding: NoInternetBinding(),
    ),
    GetPage(
      name: AppRoutes.logInScreen,
      page: () => LogInScreen(),
      binding: LogInBinding(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.classDetailsScreen,
      page: () => ClassDetailsScreen(),
      binding: ClassDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.subjectDetailsScreen,
      page: () => SubjectDetailsScreen(),
      binding: SubjectDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.viewReportsScreen,
      page: () => ViewReportsScreen(),
      binding: ViewReportBinding(),
    ),
    GetPage(
      name: AppRoutes.createQuizScreen,
      page: () => CreateQuizScreen(),
      binding: CreateQuizBinding(),
    ),
    GetPage(
      name: AppRoutes.classReportAnalyticsScreen,
      page: () => ClassReportsAnalyticsScreen(),
      binding: ClassReportsAnalyticsBindings(),
    ),
    GetPage(
      name: AppRoutes.studentDetailsScreen,
      page: () => StudentDetailsScreen(),
      binding: StudentDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.leaderboardScreen,
      page: () => LeaderboardScreen(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: AppRoutes.profileUpdateScreen,
      page: () => ProfileUpdateScreen(),
      binding: ProfileUpdateBinding(),
    )
  ];
}
