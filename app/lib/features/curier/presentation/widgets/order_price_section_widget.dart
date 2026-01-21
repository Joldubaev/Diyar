import 'package:flutter/material.dart';

/// Секция с суммой заказа
class OrderPriceSectionWidget extends StatelessWidget {
  final int totalPrice;
  final String formattedPrice;
  final ThemeData theme;

  const OrderPriceSectionWidget({
    super.key,
    required this.totalPrice,
    required this.formattedPrice,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Сумма заказа',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formattedPrice,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
