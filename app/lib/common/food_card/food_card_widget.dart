import 'package:flutter/material.dart';
import 'utils/food_image_widget.dart';
import 'utils/food_price_formatter.dart';
import 'utils/food_theme_utils.dart';

/// Константы для карточки товара
class _FoodCardConstants {
  static const double defaultElevation = 2.0;
  static const EdgeInsets defaultPadding = EdgeInsets.all(4.0);
  static const EdgeInsets defaultCardPadding = EdgeInsets.all(8.0);
  static const double defaultSpacing = 10.0;
}

/// Данные для отображения в карточке товара
class FoodCardData {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? weight;
  final int? price;

  const FoodCardData({
    this.id,
    this.name,
    this.imageUrl,
    this.weight,
    this.price,
  });
}

/// Универсальная карточка товара для использования во всем приложении
class FoodCardWidget extends StatelessWidget {
  /// Данные товара для отображения
  final FoodCardData data;

  /// Виджет для отображения справа/снизу (например, счетчик, кнопка удаления)
  final Widget? trailing;

  /// Виджет для отображения снизу (например, описание)
  final Widget? bottom;

  /// Настройки отображения
  final double? imageWidth;
  final double? imageHeight;
  final double elevation;
  final EdgeInsets? padding;
  final EdgeInsets? cardPadding;
  final VoidCallback? onTap;

  const FoodCardWidget({
    super.key,
    required this.data,
    this.trailing,
    this.bottom,
    this.imageWidth,
    this.imageHeight,
    this.elevation = _FoodCardConstants.defaultElevation,
    this.padding,
    this.cardPadding,
    this.onTap,
  });

  /// Фабричный конструктор для создания карточки из объекта с полями FoodEntity
  factory FoodCardWidget.fromFoodEntity(
    dynamic food, {
    Widget? trailing,
    Widget? bottom,
    double? imageWidth,
    double? imageHeight,
    double elevation = _FoodCardConstants.defaultElevation,
    EdgeInsets? padding,
    EdgeInsets? cardPadding,
    VoidCallback? onTap,
  }) {
    if (food == null) {
      return FoodCardWidget(
        data: const FoodCardData(),
        trailing: trailing,
        bottom: bottom,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        elevation: elevation,
        padding: padding,
        cardPadding: cardPadding,
        onTap: onTap,
      );
    }

    // Безопасное извлечение полей через динамический доступ
    final foodId = (food as dynamic).id as String?;
    final foodName = (food as dynamic).name as String?;
    final foodImageUrl = (food as dynamic).urlPhoto as String?;
    final foodWeight = (food as dynamic).weight as String?;
    final foodPrice = (food as dynamic).price as int?;

    return FoodCardWidget(
      data: FoodCardData(
        id: foodId,
        name: foodName,
        imageUrl: foodImageUrl,
        weight: foodWeight,
        price: foodPrice,
      ),
      trailing: trailing,
      bottom: bottom,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      elevation: elevation,
      padding: padding,
      cardPadding: cardPadding,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (data.id == null || data.id!.isEmpty) {
      return const SizedBox.shrink();
    }

    final borderRadius = FoodThemeUtils.getCardBorderRadius(theme);
    final imageWidth = this.imageWidth ?? FoodImageWidget.imageWidth;
    final imageHeight = this.imageHeight ?? FoodImageWidget.imageHeight;

    final cardContent = Padding(
      padding: cardPadding ?? _FoodCardConstants.defaultCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: FoodImageWidget(
              imageUrl: data.imageUrl,
              borderRadius: borderRadius,
              width: imageWidth,
              height: imageHeight,
            ),
          ),
          SizedBox(width: _FoodCardConstants.defaultSpacing),
          Expanded(
            child: _FoodCardContent(
              data: data,
              theme: theme,
              trailing: trailing,
              bottom: bottom,
            ),
          ),
        ],
      ),
    );

    final card = Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              child: cardContent,
            )
          : cardContent,
    );

    return Padding(
      padding: padding ?? _FoodCardConstants.defaultPadding,
      child: card,
    );
  }
}

/// Контент карточки товара
class _FoodCardContent extends StatelessWidget {
  final FoodCardData data;
  final ThemeData theme;
  final Widget? trailing;
  final Widget? bottom;

  const _FoodCardContent({
    required this.data,
    required this.theme,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _FoodCardHeader(
          name: data.name,
          theme: theme,
          trailing: trailing,
        ),
        _FoodCardDetails(
          weight: data.weight,
          price: data.price,
          theme: theme,
        ),
        if (bottom != null) ...[
          SizedBox(height: _FoodCardConstants.defaultSpacing),
          bottom!,
        ],
      ],
    );
  }
}

/// Заголовок карточки (название и trailing виджет)
class _FoodCardHeader extends StatelessWidget {
  final String? name;
  final ThemeData theme;
  final Widget? trailing;

  const _FoodCardHeader({
    required this.name,
    required this.theme,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = name?.isNotEmpty == true ? name! : 'Без названия';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            displayName,
            style: FoodThemeUtils.getNameTextStyle(theme),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Детали карточки (вес и цена)
class _FoodCardDetails extends StatelessWidget {
  final String? weight;
  final int? price;
  final ThemeData theme;

  const _FoodCardDetails({
    required this.weight,
    required this.price,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final weightText = weight != null ? '$weight г' : '-';
    final priceText = FoodPriceFormatter.formatPriceWithCurrency(price);

    return Row(
      children: [
        Flexible(
          child: Text(
            weightText,
            style: FoodThemeUtils.getWeightTextStyle(theme),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: _FoodCardConstants.defaultSpacing),
        Text(
          priceText,
          style: FoodThemeUtils.getPriceTextStyle(theme),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
