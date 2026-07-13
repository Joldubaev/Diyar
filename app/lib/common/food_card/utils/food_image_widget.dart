import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Константы для изображений товаров
class _FoodImageConstants {
  static const double defaultImageWidth = 120.0;
  static const double defaultImageHeight = 120.0;
  static const double placeholderSize = 50.0;
}

/// Универсальный виджет для отображения изображения товара
class FoodImageWidget extends StatelessWidget {
  final String? imageUrl;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// Стандартные размеры изображения для горизонтальной карточки
  static const double imageWidth = _FoodImageConstants.defaultImageWidth;
  static const double imageHeight = _FoodImageConstants.defaultImageHeight;

  const FoodImageWidget({
    super.key,
    required this.imageUrl,
    required this.borderRadius,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  /// Проверяет, является ли строка валидным URL изображения
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final isValidUrl = isValidImageUrl(imageUrl);
    final imageWidth = width ?? _FoodImageConstants.defaultImageWidth;
    final imageHeight = height ?? _FoodImageConstants.defaultImageHeight;

    final imageWidget = isValidUrl
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            placeholder: (context, url) => const Center(
              child: SizedBox(
                width: _FoodImageConstants.placeholderSize,
                height: _FoodImageConstants.placeholderSize,
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => _NoImagePlaceholder(
              width: imageWidth,
              height: imageHeight,
            ),
            fit: fit,
            width: imageWidth,
            height: imageHeight,
            memCacheWidth: 700,
            memCacheHeight: 700,
            filterQuality: FilterQuality.high,
          )
        : _NoImagePlaceholder(
            width: imageWidth,
            height: imageHeight,
          );

    return ClipRRect(
      borderRadius: borderRadius,
      child: imageWidget,
    );
  }
}

/// Заглушка при отсутствии или ошибке загрузки изображения товара
class _NoImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const _NoImagePlaceholder({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.broken_image_outlined,
          size: _FoodImageConstants.placeholderSize,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
