import 'package:diyar/common/counter/export.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';

import 'product_cart_dispatch.dart';
import 'product_image.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({
    super.key,
    required this.food,
    required this.quantity,
    this.isCompact = false,
  });

  final FoodEntity food;
  final int quantity;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      // height: isCompact ? null : 225.0,
      child: MediaQuery.withClampedTextScaling(
        minScaleFactor: 0.85,
        maxScaleFactor: 1.2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                spreadRadius: 0.5,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tightHeight = constraints.hasBoundedHeight;

              final textBlock = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      food.name ?? 'Название блюда',
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: isCompact ? 2 : 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 1),
                    Text.rich(
                      TextSpan(
                        text: food.weight ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.15,
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

              return Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: ProductImage(
                      food: food,
                      quantity: quantity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (tightHeight)
                    Expanded(
                      child: ClipRect(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: textBlock,
                        ),
                      ),
                    )
                  else
                    textBlock,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Center(
                      child: CounterWidget(
                        value: quantity,
                        height: 40.0,
                        borderRadius: 12.0,
                        iconSize: 20.0,
                        borderColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        textStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                        onIncrement: () => ProductCartDispatch.increment(context, food, quantity),
                        onDecrement: quantity > 0 ? () => ProductCartDispatch.decrement(context, food, quantity) : null,
                        onValueChanged: (value) => ProductCartDispatch.setCount(context, food, value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
