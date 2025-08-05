import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacher_panel/bindings/initial_bindings.dart';
import 'package:teacher_panel/config/localizations/app_localization.dart';
import 'package:teacher_panel/config/routes/app_pages.dart';
import 'package:teacher_panel/config/themes/app_theme.dart';

class MyApp extends StatelessWidget {

  final String? initialRoute;
  const MyApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(416, 886),
      builder: (_, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppLocalization(),
        fallbackLocale: const Locale('en', 'US'),
        initialRoute: initialRoute,
        getPages: AppPages.pages,
        initialBinding: InitialBindings(),
        theme: lightTheme,
        darkTheme: darkTheme,
      ),
    );
  }
}