import 'package:flutter/material.dart';

/// Варианты стилей кнопок
enum ActionButtonVariant {
  primary,
  outlined,
  outlinedSuccess,
}

/// Универсальная кнопка действия с единым стилем
class ActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final ActionButtonVariant variant;

  const ActionButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Базовый стиль для всех кнопок
    const buttonPadding = EdgeInsets.symmetric(vertical: 12);
    const buttonBorderRadius = 8.0;
    const iconSize = 18.0;

    final baseButtonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(buttonPadding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
    );

    final iconWidget = Icon(icon, size: iconSize);

    switch (variant) {
      case ActionButtonVariant.primary:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: iconWidget,
          label: Text(label),
          style: baseButtonStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(colorScheme.tertiary),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
        );

      case ActionButtonVariant.outlinedSuccess:
        final successColor = colorScheme.tertiary;
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize, color: successColor),
          label: Text(label),
          style: baseButtonStyle.copyWith(
            side: WidgetStateProperty.all(BorderSide(color: successColor)),
            foregroundColor: WidgetStateProperty.all(successColor),
          ),
        );

      case ActionButtonVariant.outlined:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: iconWidget,
          label: Text(label),
          style: baseButtonStyle,
        );
    }
  }
}
