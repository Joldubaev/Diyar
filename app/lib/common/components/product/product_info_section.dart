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
    /// Плотная вёрстка для сетки меню (меньше overflow при крупном шрифте).
    this.dense = false,
  });

  final FoodEntity food;
  final bool isCompact;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = dense ? theme.textTheme.bodyMedium : theme.textTheme.bodyLarge;
    return Padding(
      padding: ProductCardConstants.infoPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: dense ? 2 : 4),
          Text(
            food.name ?? 'Название блюда',
            style: titleStyle?.copyWith(height: dense ? 1.15 : null),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: dense ? 1 : 2),
          Text.rich(
            TextSpan(
              text: food.weight ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: dense ? 1.15 : null,
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
