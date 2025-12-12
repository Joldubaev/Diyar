import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class TotalPriceWidget extends StatelessWidget {
  final double itemsPrice;
  final double containerPrice;
  final double discountRatePercentage;
  final double monetaryDiscountAmount;
  final double finalTotalPrice;

  const TotalPriceWidget({
    super.key,
    required this.itemsPrice,
    required this.containerPrice,
    required this.discountRatePercentage,
    required this.monetaryDiscountAmount,
    required this.finalTotalPrice,
  });

  static const double _padding = 16.0;
  static const double _borderRadius = 12.0;
  static const double _shadowBlur = 8.0;
  static const Offset _shadowOffset = Offset(0, 2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: _shadowBlur,
            offset: _shadowOffset,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PriceRowWidget(label: l10n.costOfMeal, value: itemsPrice),
          if (containerPrice > 0) PriceRowWidget(label: 'Стоимость контейнера', value: containerPrice),
          PriceRowWidget(
            label: "Скидка (${discountRatePercentage.toInt()}%)",
            value: -monetaryDiscountAmount,
            valueColor: theme.colorScheme.error,
          ),
          const Divider(height: 20, thickness: 1),
          PriceRowWidget(
            label: l10n.total,
            value: finalTotalPrice,
            isTotal: true,
          ),
          Text(
            'Цена без учета доставки',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
