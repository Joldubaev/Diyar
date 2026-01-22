import 'package:flutter/material.dart';

/// Секция с суммой заказа и бонусами
class OrderPriceSectionWidget extends StatelessWidget {
  final int totalPrice;
  final String formattedPrice;
  final double? bonusAmount;
  final ThemeData theme;

  const OrderPriceSectionWidget({
    super.key,
    required this.totalPrice,
    required this.formattedPrice,
    this.bonusAmount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final bonus = bonusAmount ?? 0.0;
    final finalTotal = totalPrice - bonus;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (bonus > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Бонусы',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  bonus % 1 == 0
                      ? '${bonus.toInt()} сом'
                      : '${bonus.toStringAsFixed(2)} сом',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Итого',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                finalTotal % 1 == 0
                    ? '${finalTotal.toInt()} сом'
                    : '${finalTotal.toStringAsFixed(2)} сом',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
