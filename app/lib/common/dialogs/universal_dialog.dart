import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Универсальный кастомный диалог с поддержкой iOS и Android
///
/// Используется для отображения диалоговых окон с поддержкой обеих платформ
class UniversalDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final String? message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showCancelButton;
  final bool showConfirmButton;
  final bool confirmIsDestructive;
  final bool cancelIsDestructive;
  final Widget? customContent;

  const UniversalDialog({
    super.key,
    this.title,
    this.content,
    this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showCancelButton = true,
    this.showConfirmButton = true,
    this.confirmIsDestructive = false,
    this.cancelIsDestructive = false,
    this.customContent,
  });

  /// Показывает универсальный диалог
  ///
  /// [context] - контекст для отображения диалога
  /// [title] - заголовок диалога
  /// [message] - текстовое сообщение (альтернатива content)
  /// [content] - виджет контента (альтернатива message)
  /// [confirmText] - текст кнопки подтверждения
  /// [cancelText] - текст кнопки отмены
  /// [onConfirm] - callback при нажатии на подтверждение
  /// [onCancel] - callback при нажатии на отмену
  /// [showCancelButton] - показывать ли кнопку отмены
  /// [showConfirmButton] - показывать ли кнопку подтверждения
  /// [confirmIsDestructive] - является ли кнопка подтверждения деструктивной (красной)
  /// [cancelIsDestructive] - является ли кнопка отмены деструктивной (красной)
  ///
  /// Возвращает результат: true при подтверждении, false при отмене, null при закрытии
  static Future<bool?> show({
    required BuildContext context,
    String? title,
    Widget? content,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancelButton = true,
    bool showConfirmButton = true,
    bool confirmIsDestructive = false,
    bool cancelIsDestructive = false,
    Widget? customContent,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => UniversalDialog(
        title: title,
        content: content,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm != null
            ? () {
                onConfirm();
                Navigator.of(dialogContext).pop(true);
              }
            : () => Navigator.of(dialogContext).pop(true),
        onCancel: onCancel != null
            ? () {
                onCancel();
                Navigator.of(dialogContext).pop(false);
              }
            : () => Navigator.of(dialogContext).pop(false),
        showCancelButton: showCancelButton,
        showConfirmButton: showConfirmButton,
        confirmIsDestructive: confirmIsDestructive,
        cancelIsDestructive: cancelIsDestructive,
        customContent: customContent,
      ),
    );
    return result;
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
    final dialogContent = customContent ?? content ?? (message != null ? Text(message!) : const SizedBox.shrink());

    return CupertinoAlertDialog(
      title: title != null ? Text(title!) : null,
      content: dialogContent,
      actions: [
        if (showCancelButton)
          CupertinoDialogAction(
            isDestructiveAction: cancelIsDestructive,
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            child: Text(cancelText ?? 'Отмена'),
          ),
        if (showConfirmButton)
          CupertinoDialogAction(
            isDestructiveAction: confirmIsDestructive,
            isDefaultAction: true,
            onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
            child: Text(confirmText ?? 'OK'),
          ),
      ],
    );
  }

  Widget _buildMaterialDialog(BuildContext context) {
    final theme = Theme.of(context);
    final dialogContent = customContent ?? content ?? (message != null ? Text(message!) : const SizedBox.shrink());

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: title != null
          ? const EdgeInsets.fromLTRB(24, 20, 24, 0)
          : const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      contentPadding: EdgeInsets.fromLTRB(24, title != null ? 16 : 20, 24, 16),
      title: title != null
          ? Text(
              title!,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      content: dialogContent is Text
          ? Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            )
          : dialogContent,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actions: [
        if (showCancelButton)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: cancelIsDestructive ? theme.colorScheme.error : theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
              foregroundColor: cancelIsDestructive ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            child: Text(cancelText ?? 'Отмена'),
          ),
        if (showCancelButton && showConfirmButton) const SizedBox(width: 12),
        if (showConfirmButton)
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor:
                  confirmIsDestructive ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer,
              foregroundColor:
                  confirmIsDestructive ? theme.colorScheme.onErrorContainer : theme.colorScheme.onPrimaryContainer,
            ),
            onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
            child: Text(confirmText ?? 'OK'),
          ),
      ],
    );
  }
}
