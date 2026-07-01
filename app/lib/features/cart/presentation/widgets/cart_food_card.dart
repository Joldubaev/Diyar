import 'package:diyar/common/counter/export.dart';
import 'package:diyar/common/food_card/export.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';

/// Константы карточки блюда в корзине.
class _CartCardConstants {
  static const double imageSize = 64.0;
  static const double spacing = 12.0;
  static const double counterHeight = 36.0;
  static const double borderRadius = 12.0;
  static const EdgeInsets padding = EdgeInsets.symmetric(vertical: 12);
}

/// Карточка блюда в корзине в плоском стиле:
/// фото слева, по центру — название + подзаголовок + строка «цена · вес»,
/// счётчик справа по вертикальному центру.
///
/// Слот [subtitle] зарезервирован под выбранный гарнир (пока не заполняется).
class CartFoodCard extends StatelessWidget {
  final FoodEntity food;
  final int counter;

  /// Подзаголовок под названием (напр. выбранный гарнир). Скрыт, если пуст.
  final String? subtitle;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onMinReached;
  final VoidCallback? onTap;

  const CartFoodCard({
    super.key,
    required this.food,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.onMinReached,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(_CartCardConstants.borderRadius);

    final content = Padding(
      padding: _CartCardConstants.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _CartCardConstants.imageSize,
            height: _CartCardConstants.imageSize,
            child: FoodImageWidget(
              imageUrl: food.imageUrlForList,
              borderRadius: borderRadius,
              width: _CartCardConstants.imageSize,
              height: _CartCardConstants.imageSize,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: _CartCardConstants.spacing),
          Expanded(child: _CartFoodInfo(food: food, subtitle: subtitle, theme: theme)),
          const SizedBox(width: _CartCardConstants.spacing),
          CounterWidget(
            value: counter,
            height: _CartCardConstants.counterHeight,
            onIncrement: onIncrement,
            onDecrement: () {
              if (counter > 1) onDecrement();
            },
            onMinReached: onMinReached,
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, borderRadius: borderRadius, child: content);
  }
}

/// Центральный блок: название, подзаголовок и строка «цена · вес».
class _CartFoodInfo extends StatelessWidget {
  final FoodEntity food;
  final String? subtitle;
  final ThemeData theme;

  const _CartFoodInfo({required this.food, required this.subtitle, required this.theme});

  @override
  Widget build(BuildContext context) {
    final name = food.name?.isNotEmpty == true ? food.name! : 'Без названия';
    final priceText = FoodPriceFormatter.formatPriceWithCurrency(food.price);
    final weight = food.weight;
    final subtitleText = subtitle;
    final mutedColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitleText != null && subtitleText.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            subtitleText,
            style: theme.textTheme.bodySmall?.copyWith(color: mutedColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: priceText,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (weight != null && weight.isNotEmpty)
                TextSpan(
                  text: ' · $weight',
                  style: theme.textTheme.bodyMedium?.copyWith(color: mutedColor),
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
