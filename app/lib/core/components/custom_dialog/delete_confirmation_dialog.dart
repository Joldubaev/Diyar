import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Универсальный диалог подтверждения удаления с поддержкой iOS и Android
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? cancelText;
  final String? deleteText;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText,
    this.deleteText,
  });

  /// Показывает диалог подтверждения удаления
  /// Возвращает true, если пользователь подтвердил удаление
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String? cancelText,
    String? deleteText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DeleteConfirmationDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        deleteText: deleteText,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoDialog(context);
    } else {
      return _buildMaterialDialog(context);
    }
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText ?? 'Отмена'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(deleteText ?? 'Удалить'),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
            foregroundColor: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText ?? 'Отмена'),
        ),
        const SizedBox(width: 12),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.errorContainer,
            foregroundColor: theme.colorScheme.onErrorContainer,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(deleteText ?? 'Удалить'),
        ),
      ],
    );
  }
}
