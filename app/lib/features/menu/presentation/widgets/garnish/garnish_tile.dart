import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

/// Карточка гарнира для горизонтального списка: фото сверху, название, цена
/// и индикатор выбора.
///
/// [imageUrl] == null → пункт без фото (например, «Без гарнира»): вместо фото
/// показывается нейтральная заглушка.
class GarnishTile extends StatelessWidget {
  const GarnishTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.imageUrl,
    this.trailing,
  });

  final String title;
  final String? imageUrl;
  final String? trailing;
  final bool selected;
  final VoidCallback onTap;

  static const double cardWidth = 132;
  static const double _imageHeight = 92;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? context.colorScheme.primary : context.colorScheme.outlineVariant;
    return SizedBox(
      width: cardWidth,
      child: Material(
        color: selected
            ? context.colorScheme.primary.withValues(alpha: 0.06)
            : context.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: selected ? 1.6 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    _buildImage(context),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Icon(
                        selected ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 20,
                        color: selected
                            ? context.colorScheme.primary
                            : context.colorScheme.surface.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (trailing != null) ...[
                  const Spacer(),
                  const SizedBox(height: 4),
                  Text(
                    trailing!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final placeholderColor = context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final url = imageUrl;

    if (url == null || url.isEmpty) {
      return Container(
        width: double.infinity,
        height: _imageHeight,
        decoration: BoxDecoration(
          color: placeholderColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.restaurant_outlined,
          size: 28,
          color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: _imageHeight,
        fit: BoxFit.cover,
        memCacheWidth: 300,
        placeholder: (_, __) => Container(color: placeholderColor),
        errorWidget: (_, __, ___) => Container(
          color: placeholderColor,
          child: Icon(
            Icons.broken_image_outlined,
            size: 24,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
