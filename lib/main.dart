import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teacher_panel/my_app.dart';
import 'package:teacher_panel/routes/app_routes.dart';
import 'package:teacher_panel/services/connectivity_service.dart';
import 'package:teacher_panel/services/hive_service.dart';
import 'package:teacher_panel/services/shared_preference_service.dart';
import 'package:teacher_panel/utils/question.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await SharedPreferencesService().init(); // Initialize SharedPreferences
  await Hive.initFlutter();  // Initialize Hive
  Hive.registerAdapter(QuestionAdapter());
  await HiveService().init();
  final hasInternet = await ConnectivityService.isConnected();
  final userId = SharedPreferencesService().getUserId();
  runApp( MyApp(
    initialRoute: hasInternet
        ? (userId.isNotEmpty
        ? AppRoutes.homeScreen
        : AppRoutes.logInScreen)
        : AppRoutes.noInternetScreen,
  ));
}


