import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'product_card_constants.dart';

/// Image area with quantity overlay animation.
class ProductImageSection extends StatelessWidget {
  final FoodEntity food;
  final VoidCallback? onTap;
  final Animation<double> overlayOpacityAnimation;
  final int quantity;
  final double imageWidth;
  final double imageHeight;
  final bool isCompact;

  /// Для сетки меню: [BoxFit.cover] заполняет рамку без «полос» при [BoxFit.contain].
  final BoxFit imageBoxFit;

  const ProductImageSection({
    super.key,
    required this.food,
    this.onTap,
    required this.overlayOpacityAnimation,
    required this.quantity,
    required this.imageWidth,
    required this.imageHeight,
    this.isCompact = false,
    this.imageBoxFit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: ProductCardConstants.cardPadding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ProductCardConstants.cardBorderRadius),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: ColoredBox(
                  color: theme.colorScheme.surface,
                  child: CachedNetworkImage(
                    imageUrl: food.urlPhoto ?? 'https://via.placeholder.com/150',
                    placeholder: (_, __) => _Placeholder(
                      width: imageWidth,
                      height: imageHeight,
                    ),
                    errorWidget: (_, __, ___) => _ErrorWidget(
                      width: imageWidth,
                      height: imageHeight,
                    ),
                    memCacheWidth: ProductCardConstants.memCacheWidth,
                    memCacheHeight: ProductCardConstants.memCacheHeight,
                    cacheManager: DefaultCacheManager(),
                    fit: imageBoxFit,
                    alignment: Alignment.center,
                    width: imageWidth,
                    height: imageHeight,
                  ),
                ),
              ),
              _QuantityOverlay(
                animation: overlayOpacityAnimation,
                quantity: quantity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityOverlay extends StatelessWidget {
  const _QuantityOverlay({required this.animation, required this.quantity});

  final Animation<double> animation;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: FadeTransition(
        opacity: animation,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.75),
            ),
            child: Center(
              child: Text(
                '$quantity',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surface.withValues(alpha: 0.5),
      child: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surface.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 4),
          Text(
            'Нет фото',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
