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
    return MediaQuery.withClampedTextScaling(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Фото впритык к краям карточки (без внутреннего отступа),
            // скругление совпадает с верхними углами карточки.
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                      // Фото целиком, без обрезки и без заливки полей.
                      child: ProductImage(
                        food: food,
                        quantity: quantity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: _OverlayCounter(food: food, quantity: quantity),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (food.price != null)
                    Text(
                      '${food.price} сом',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    food.name ?? 'Название блюда',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.2,
                    ),
                    maxLines: isCompact ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (food.weight != null && food.weight!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      food.weight!,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.2,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverlayCounter extends StatelessWidget {
  const _OverlayCounter({required this.food, required this.quantity});

  final FoodEntity food;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (quantity == 0) {
      return Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: () => ProductCartDispatch.increment(context, food, quantity),
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              Icons.add,
              size: 22,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black26,
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => ProductCartDispatch.decrement(context, food, quantity),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  Icons.remove,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 18),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ),
            InkWell(
              onTap: () => ProductCartDispatch.increment(context, food, quantity),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  Icons.add,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
