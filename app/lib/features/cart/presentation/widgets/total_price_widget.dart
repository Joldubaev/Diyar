import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TotalPriceWidget extends StatelessWidget {
  final double itemsPrice;
  final double containerPrice;
  final double discountPercentage;
  final double finalTotalPrice;

  const TotalPriceWidget({
    super.key,
    required this.itemsPrice,
    required this.containerPrice,
    required this.discountPercentage,
    required this.finalTotalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final discountAmount = itemsPrice * discountPercentage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          PriceRowWidget(label: l10n.costOfMeal, value: itemsPrice),
          if (containerPrice > 0) PriceRowWidget(label: 'dishCountLabelCost', value: containerPrice),
          PriceRowWidget(
            label: "Скидка (${(discountPercentage * 100).toInt()}%)",
            value: -discountAmount,
            valueColor: theme.colorScheme.error,
          ),
          const Divider(height: 20, thickness: 1),
          PriceRowWidget(
            label: l10n.total,
            value: finalTotalPrice,
            isTotal: true,
          ),
          Text(
            'Ценна без учета доставки',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
