
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductImage extends StatelessWidget {
  final FoodEntity food;

  const ProductImage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: surface,
          child: CachedNetworkImage(
            imageUrl: food.urlPhoto ?? 'https://i.ibb.co/GkL25DB/ALE-1357-7.png',
            memCacheWidth: 800,
            memCacheHeight: 600,
            filterQuality: FilterQuality.medium,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            errorWidget: (context, url, error) => _buildErrorWidget(context),
            placeholder: (context, url) => _buildLoadingWidget(surface),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Не удалось загрузить изображение',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget(Color background) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ColoredBox(color: background),
    );
  }
}
