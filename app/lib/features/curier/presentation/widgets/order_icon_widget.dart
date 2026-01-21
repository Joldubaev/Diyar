import 'package:flutter/material.dart';

/// Иконка заказа в заголовке
class OrderIconWidget extends StatelessWidget {
  final ThemeData theme;

  const OrderIconWidget({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: theme.colorScheme.primary,
        size: 24,
      ),
    );
  }
}
