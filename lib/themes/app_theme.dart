import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teacher_panel/utils/app_colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightBgClr,
  useMaterial3: true,
  fontFamily: 'Noto Sans Bengali',
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryClr,
      onPrimary: lightFontClr,
      secondary: lightCardClr,
      onSecondary: lightFontClr,
      error: redClr,
      onError: lightBgClr,
      surface: lightCardClr,
      onSurface: lightFontClr),
  textTheme: TextTheme(
    bodyLarge:
        TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w400, height: 1),
    bodyMedium:
        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, height: 1),
    bodySmall:
        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, height: 1),
    titleLarge:
        TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w700, height: 1),
    titleMedium:
        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1),
    titleSmall:
        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, height: 1),
  ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryClr.withValues(alpha: 0.1),
      hintStyle: TextStyle(fontSize: 20.sp, color: Colors.grey, fontFamily: 'Noto Sans Bengali', fontWeight: FontWeight.w400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: primaryClr, width: 2.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: primaryClr, width: 2.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: primaryClr, width: 2.w),
      ),
    )
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBgClr,
  fontFamily: 'Noto Sans Bengali',
  useMaterial3: true,
  colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryClr,
      onPrimary: darkFontClr,
      secondary: darkCardClr,
      onSecondary: darkFontClr,
      error: redClr,
      onError: lightBgClr,
      surface: darkCardClr,
      onSurface: darkFontClr),
  textTheme: TextTheme(
    bodyLarge:
        TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w400, height: 1),
    bodyMedium:
        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, height: 1),
    bodySmall:
        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, height: 1),
    titleLarge:
        TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w700, height: 1),
    titleMedium:
        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1),
    titleSmall:
        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, height: 1),
  ),
);
