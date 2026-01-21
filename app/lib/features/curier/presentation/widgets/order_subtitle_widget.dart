import 'package:flutter/material.dart';

/// Подзаголовок с ценой
class OrderSubtitleWidget extends StatelessWidget {
  final String price;
  final ThemeData theme;

  const OrderSubtitleWidget({
    super.key,
    required this.price,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        price,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
