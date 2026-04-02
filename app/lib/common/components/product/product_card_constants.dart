import 'package:flutter/material.dart';

/// Shared constants for the product card widgets.
abstract final class ProductCardConstants {
  static const double cardBorderRadius = 10.0;
  static const double reservedBelowImage = 108.0;
  static const double imageWidth = 170.0;
  static const int memCacheWidth = 400;
  static const int memCacheHeight = 400;
  static const double counterHeight = 35.0;
  static const double counterBorderRadius = 30.0;
  static const Duration overlayFadeInDuration = Duration(milliseconds: 150);
  static const Duration overlayVisibleDuration = Duration(milliseconds: 400);
  static const EdgeInsets cardPadding = EdgeInsets.all(4.0);
  static const EdgeInsets infoPadding = EdgeInsets.symmetric(horizontal: 6.0);
  static const EdgeInsets counterMargin = EdgeInsets.symmetric(horizontal: 10.0);
}
