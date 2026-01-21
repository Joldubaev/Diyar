import 'package:flutter/material.dart';

/// Кнопка звонка в заголовке
class CallButtonWidget extends StatelessWidget {
  final VoidCallback onCall;
  final ThemeData theme;

  const CallButtonWidget({
    super.key,
    required this.onCall,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // Используем success цвет из ColorScheme или tertiary как fallback
    final successColor = theme.colorScheme.tertiary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onCall,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: successColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: successColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.phone,
            color: successColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
