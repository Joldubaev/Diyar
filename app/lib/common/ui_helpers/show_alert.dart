import 'package:diyar/common/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class AppAlert {
  static Future<T?> showLoading<T>(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return showAdaptiveDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text('Loading', style: Theme.of(context).textTheme.titleLarge),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CupertinoActivityIndicator(color: theme.primaryColor, radius: 16),
          ),
        );
      },
    );
  }

  static Future<T?> showConfirmDialog<T>({
    required BuildContext context,
    required String title,
    Widget? content,
    bool showCancelButton = true,
    bool showConfirmButton = true,
    String? cancelText,
    String? confirmText,
    bool cancelIsDefault = false,
    bool cancelIsDestructive = false,
    bool confirmlIsDefault = false,
    bool confirmIsDestructive = false,
    void Function()? cancelPressed,
    void Function()? confirmPressed,
    void Function()? onFinish,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          content: content,
          actions: [
            if (showCancelButton)
              CupertinoDialogAction(
                isDefaultAction: cancelIsDefault,
                isDestructiveAction: cancelIsDestructive,
                onPressed: cancelPressed ?? () => Navigator.pop(context),
                child: Text(cancelText ?? 'Нет'),
              ),
            if (showConfirmButton)
              ConfirmButton(
                confirmText: confirmText,
                confirmIsDestructive: confirmIsDestructive,
                confirmPressed: confirmPressed,
                confirmlIsDefault: confirmlIsDefault,
                onFinish: onFinish,
              ),
          ],
        );
      },
    );
  }
}
