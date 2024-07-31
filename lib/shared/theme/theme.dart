// IMPORTS
import 'package:flutter/material.dart';
import 'app_colors.dart';

// EXPORTS
export 'app_colors.dart';

final lightTheme = ThemeData(
  primaryColor: AppColors.primary,
  primarySwatch: AppColors.primary,
  fontFamily: "Roboto",
  scaffoldBackgroundColor: const Color(0xffFAFAFA),
  colorScheme: const ColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.primary,
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
    foregroundColor: Colors.black,
    surfaceTintColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.black1,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.black1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.black1,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedLabelStyle: TextStyle(fontSize: 14),
    unselectedLabelStyle: TextStyle(fontSize: 14),
  ),
);

final darkTheme = ThemeData(
  primaryColor: AppColors.primary,
  primarySwatch: AppColors.primary,
  fontFamily: "Roboto",
  scaffoldBackgroundColor: const Color(0xff121212),
  colorScheme: const ColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.primary,
    surface: Color(0xff1E1E1E),
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xff1E1E1E),
    titleTextStyle: TextStyle(fontSize: 16, color: Colors.white),
    foregroundColor: Colors.white,
    surfaceTintColor: Color(0xff1E1E1E),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  ),
);
