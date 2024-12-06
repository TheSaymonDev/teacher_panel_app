import 'package:get/get.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/screens/add_class_screen/add_class_screen.dart';
import 'package:teacher_panel/screens/add_class_screen/bindings/add_class_binding.dart';
import 'package:teacher_panel/screens/class_details_screen/class_details_screen.dart';
import 'package:teacher_panel/screens/home_screen/home_screen.dart';
import 'package:teacher_panel/screens/log_in_screen/bindings/log_in_binding.dart';
import 'package:teacher_panel/screens/log_in_screen/log_in_screen.dart';
import 'package:teacher_panel/screens/no_internet_screen/bindings/no_internet_binding.dart';
import 'package:teacher_panel/screens/no_internet_screen/no_internet_screen.dart';
import 'package:teacher_panel/screens/question_screen/bindings/question_binding.dart';
import 'package:teacher_panel/screens/question_screen/question_screen.dart';
import 'package:teacher_panel/screens/view_reports_screen/view_reports_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: AppRoutes.noInternetScreen,
        page: () => NoInternetScreen(),
        binding: NoInternetBinding()),
    GetPage(
        name: AppRoutes.logInScreen,
        page: () => LogInScreen(),
        binding: LogInBinding()),
    GetPage(name: AppRoutes.homeScreen, page: () => HomeScreen()),
    GetPage(
        name: AppRoutes.classDetailsScreen, page: () => ClassDetailsScreen()),
    GetPage(
        name: AppRoutes.addClassScreen,
        page: () => AddClassScreen(),
        binding: AddClassBinding()),
    GetPage(name: AppRoutes.viewReportsScreen, page: () => ViewReportsScreen()),
    GetPage(
        name: AppRoutes.questionScreen,
        page: () => QuestionScreen(),
        binding: QuestionBinding())
  ];
}
