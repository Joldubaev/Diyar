import 'package:flutter/material.dart';

/// Shared constants for the product card widgets.
abstract final class ProductCardConstants {
  /// Скругление карточки и блока фото (макет: 16 dp).
  static const double cardBorderRadius = 16.0;

  /// Соотношение сторон плитки в сетке 2 колонки: ширина : высота (запас под текст/счётчик).
  static const double gridTileChildAspectRatio = 156 / 246;

  /// Fallback ширина блока фото (≈ ширина плитки минус отступы карточки).
  static const double imageWidth = 156.0;
  static const int memCacheWidth = 400;
  static const int memCacheHeight = 400;
  static const double counterHeight = 32.0;
  static const double counterBorderRadius = 30.0;
  static const Duration overlayFadeInDuration = Duration(milliseconds: 150);
  static const Duration overlayVisibleDuration = Duration(milliseconds: 400);
  static const EdgeInsets cardPadding = EdgeInsets.all(4.0);
  static const EdgeInsets infoPadding = EdgeInsets.symmetric(horizontal: 6.0);
  static const EdgeInsets counterMargin = EdgeInsets.symmetric(horizontal: 10.0);

  /// Ширина карточки относительно ячейки masonry на главной («Популярные блюда»).
  static const double popularMasonryCardWidthFactor = 0.82;

  /// Квадрат превью в компактной карточке: не больше [compactImageMaxSide], без растягивания фото.
  static const double compactImageMinSide = 44.0;
  static const double compactImageMaxSide = 100.0;
}
