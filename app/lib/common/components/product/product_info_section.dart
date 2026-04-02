import 'package:diyar/core/core.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';

import 'product_card_constants.dart';

/// Displays food name, weight, and price.
class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    super.key,
    required this.food,
    this.isCompact = false,
  });

  final FoodEntity food;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: ProductCardConstants.infoPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            food.name ?? 'Название блюда',
            style: theme.textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              text: food.weight ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                if (food.price != null)
                  TextSpan(
                    text: ' - ${food.price} сом',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
