import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A reusable increment/decrement counter widget.
class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.minValue = 0,
    this.maxValue = 99,
    this.size = 32,
    this.iconSize = 18,
    this.backgroundColor,
    this.iconColor,
    this.textStyle,
  });

  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minValue;
  final int maxValue;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primary;
    final ic = iconColor ?? Colors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleButton(
          icon: Icons.remove,
          onTap: count > minValue ? onDecrement : null,
          size: size,
          iconSize: iconSize,
          backgroundColor: bg,
          iconColor: ic,
        ),
        SizedBox(
          width: size,
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: textStyle ??
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
          ),
        ),
        _CircleButton(
          icon: Icons.add,
          onTap: count < maxValue ? onIncrement : null,
          size: size,
          iconSize: iconSize,
          backgroundColor: bg,
          iconColor: ic,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isEnabled
              ? backgroundColor
              : backgroundColor.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
