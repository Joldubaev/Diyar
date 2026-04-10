import 'package:flutter/material.dart';

enum ActionButtonVariant { primary, outlined, outlinedSuccess }

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.variant,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final ActionButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const padding = EdgeInsets.symmetric(vertical: 12);
    const radius = 8.0;
    const iconSize = 18.0;

    final base = ButtonStyle(
      padding: WidgetStateProperty.all(padding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );

    final iconWidget = Icon(icon, size: iconSize);

    return switch (variant) {
      ActionButtonVariant.primary => ElevatedButton.icon(
          onPressed: onPressed,
          icon: iconWidget,
          label: Text(label),
          style: base.copyWith(
            backgroundColor:
                WidgetStateProperty.all(colorScheme.tertiary),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),
      ActionButtonVariant.outlinedSuccess => OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize, color: colorScheme.tertiary),
          label: Text(label),
          style: base.copyWith(
            side: WidgetStateProperty.all(
              BorderSide(color: colorScheme.tertiary),
            ),
            foregroundColor:
                WidgetStateProperty.all(colorScheme.tertiary),
          ),
        ),
      ActionButtonVariant.outlined => OutlinedButton.icon(
          onPressed: onPressed,
          icon: iconWidget,
          label: Text(label),
          style: base,
        ),
    };
  }
}
