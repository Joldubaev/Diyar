import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeContextExtension on BuildContext {
  // Короткий доступ к теме
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Короткий доступ к основным цветам проекта
  Color get primaryColor => theme.primaryColor;
  Color get scaffoldBg => theme.scaffoldBackgroundColor;

  // Умные уведомления (замена твоему SnackBarMessage)
  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating, // Чтобы не перекрывало BottomSheet
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }
}
