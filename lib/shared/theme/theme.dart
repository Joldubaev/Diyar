// IMPORTS
import 'package:flutter/material.dart';
import 'app_colors.dart';

// EXPORTS
export 'app_colors.dart';

ThemeData theme = ThemeData(
  primaryColor: AppColors.primary,
  primarySwatch: AppColors.primary,
  fontFamily: "Roboto",
  scaffoldBackgroundColor: const Color(0xffFAFAFA),
  colorScheme: const ColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.primary,
    surface: Colors.white, // Replaced background with surface
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
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  ),
);
