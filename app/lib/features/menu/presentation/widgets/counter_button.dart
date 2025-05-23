
import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isIncrement;

  const CounterButton({super.key, 
    required this.icon,
    this.onPressed,
    this.isIncrement = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;
    final buttonSize = 48.0;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      elevation: isEnabled ? 2.0 : 0.0,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: isEnabled
                ? (isIncrement ? theme.colorScheme.primary : theme.colorScheme.secondaryContainer)
                : theme.disabledColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 26,
            color: isEnabled
                ? (isIncrement ? theme.colorScheme.onPrimary : theme.colorScheme.onSecondaryContainer)
                : theme.disabledColor,
          ),
        ),
      ),
    );
  }
}
