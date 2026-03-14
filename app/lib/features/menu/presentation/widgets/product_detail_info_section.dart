import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';

/// Секция экрана продукта: название, вес, цена, описание, состав, аллергены.
class ProductDetailInfoSection extends StatelessWidget {
  const ProductDetailInfoSection({super.key, required this.food});

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          food.name ?? 'Название продукта',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (food.weight != null && food.weight!.isNotEmpty)
              Text(
                food.weight!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            Text(
              '${food.price ?? '0'} сом',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (food.description != null && food.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            food.description!,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
        if (food.ingredients != null && food.ingredients!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Состав',
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: food.ingredients!.map((e) => _IngredientChip(ingredient: e)).toList(),
          ),
        ],
        if (food.allergens != null && food.allergens!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Аллергены',
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allergensSorted(food.allergens!).map((e) => _AllergenChip(allergen: e)).toList(),
          ),
        ],
      ],
    );
  }
}

List<AllergenEntity> _allergensSorted(List<AllergenEntity> list) {
  final copy = List<AllergenEntity>.from(list);
  copy.sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
  return copy;
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.ingredient});

  final IngredientEntity ingredient;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: context.colorScheme.primary.withValues(alpha: 0.08),
      shape: const StadiumBorder(),
      side: BorderSide.none,
      avatar: (ingredient.urlPhoto != null && ingredient.urlPhoto!.isNotEmpty)
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: ingredient.urlPhoto!,
                width: 24,
                height: 24,
                memCacheWidth: 48,
                memCacheHeight: 48,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                placeholder: (_, __) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.fastfood, size: 20),
              ),
            )
          : null,
      label: Text(ingredient.name ?? '', style: context.textTheme.bodySmall),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class _AllergenChip extends StatelessWidget {
  const _AllergenChip({required this.allergen});

  final AllergenEntity allergen;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: context.colorScheme.error.withValues(alpha: 0.1),
      shape: const StadiumBorder(),
      side: BorderSide.none,
      label: Text(
        allergen.name ?? '',
        style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.error),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
