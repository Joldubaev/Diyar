import 'dart:io' show Platform;
import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthDialogs {
  static void showExitDialog(BuildContext context, VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (context) => CustomDialogWidget(
        content: const Text("Вы уверены, что хотите выйти?"),
        onOk: () {
          Navigator.of(context).pop();
          onOkPressed();
        },
        onCancel: () => context.maybePop(),
        onOkText: const Text("Да", style: TextStyle(color: AppColors.red)),
        onCancelText: const Text(
          "Нет",
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  static void showNoBiometricsDialog(BuildContext context) {
    final title = "Биометрия недоступна";
    final content = "Биометрическая аутентификация не настроена на вашем устройстве.";
    final okText = "OK";

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          backgroundColor: AppColors.white,
          content: Text(content),
          actions: [
            AppTextButton(
              onPressed: () => Navigator.of(context).pop(),
              label: okText,
            ),
          ],
        ),
      );
    } else if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(okText),
            ),
          ],
        ),
      );
    }
  }

  static void showFailedAuth(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialogWidget(
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: AppColors.red,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              "Ошибка аутентификации",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        onOk: () => context.maybePop(),
        onOkText: const Text(
          "Попробовать снова",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
