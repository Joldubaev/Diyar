import 'package:flutter/material.dart';

/// Константы для виджета счетчика
class _CounterConstants {
  static const double defaultHeight = 40.0;
  static const double defaultBorderRadius = 30.0;
  static const double defaultIconSize = 20.0;
  static const double defaultSplashRadius = 20.0;
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets defaultTextPadding = EdgeInsets.symmetric(horizontal: 8);
}

/// Универсальный виджет счетчика для увеличения/уменьшения значений
class CounterWidget extends StatelessWidget {
  /// Текущее значение счетчика
  final int value;

  /// Минимальное значение (по умолчанию 0)
  final int minValue;

  /// Максимальное значение (null = без ограничений)
  final int? maxValue;

  /// Callback при увеличении значения
  final VoidCallback? onIncrement;

  /// Callback при уменьшении значения
  final VoidCallback? onDecrement;

  /// Callback при достижении минимального значения (например, удаление)
  final VoidCallback? onMinReached;

  /// Высота виджета
  final double? height;

  /// Радиус скругления границ
  final double? borderRadius;

  /// Размер иконок
  final double? iconSize;

  /// Цвет границы
  final Color? borderColor;

  /// Стиль текста
  final TextStyle? textStyle;

  /// Отключен ли счетчик
  final bool enabled;

  const CounterWidget({
    super.key,
    required this.value,
    this.minValue = 0,
    this.maxValue,
    this.onIncrement,
    this.onDecrement,
    this.onMinReached,
    this.height,
    this.borderRadius,
    this.iconSize,
    this.borderColor,
    this.textStyle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (value < minValue) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveHeight = height ?? _CounterConstants.defaultHeight;
    final effectiveBorderRadius = borderRadius ?? _CounterConstants.defaultBorderRadius;
    final effectiveIconSize = iconSize ?? _CounterConstants.defaultIconSize;
    final effectiveBorderColor = borderColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.2);
    final effectiveTextStyle = textStyle ?? theme.textTheme.bodyLarge;

    final canDecrement = enabled && value > minValue;
    final effectiveMaxValue = maxValue;
    final canIncrement = enabled && (effectiveMaxValue == null || value < effectiveMaxValue);

    return Container(
      height: effectiveHeight,
      padding: _CounterConstants.defaultPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(color: effectiveBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            splashRadius: _CounterConstants.defaultSplashRadius,
            iconSize: effectiveIconSize,
            icon: const Icon(Icons.remove),
            onPressed: canDecrement
                ? () {
                    if (value == minValue + 1 && onMinReached != null) {
                      onMinReached!();
                    } else if (onDecrement != null) {
                      onDecrement!();
                    }
                  }
                : null,
            color: canDecrement ? null : theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          Padding(
            padding: _CounterConstants.defaultTextPadding,
            child: Text(
              value.toString(),
              style: effectiveTextStyle,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            splashRadius: _CounterConstants.defaultSplashRadius,
            iconSize: effectiveIconSize,
            icon: const Icon(Icons.add),
            onPressed: canIncrement ? onIncrement : null,
            color: canIncrement ? null : theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
        ],
      ),
    );
  }
}
