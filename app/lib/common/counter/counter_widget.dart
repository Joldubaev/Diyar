import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Константы для виджета счетчика
class _CounterConstants {
  static const double defaultHeight = 40.0;
  static const double defaultBorderRadius = 44.0;
  static const double defaultIconSize = 24.0;
  static const double fieldWidth = 40.0;
}

/// Универсальный виджет счетчика для увеличения/уменьшения значений
class CounterWidget extends StatefulWidget {
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

  /// Callback при изменении значения в поле (если null — только текст, без ввода)
  final ValueChanged<int>? onValueChanged;

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
    this.onValueChanged,
    this.height,
    this.borderRadius,
    this.iconSize,
    this.borderColor,
    this.textStyle,
    this.enabled = true,
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFieldChanged(String value) {
    if (widget.onValueChanged == null) return;
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) return;
    final max = widget.maxValue;
    final upper = max ?? parsed;
    final clamped = parsed.clamp(widget.minValue, upper);
    if (clamped <= 0) return;
    widget.onValueChanged!(clamped);
  }

  void _onDecrementTap() {
    if (widget.value == widget.minValue + 1 && widget.onMinReached != null) {
      widget.onMinReached!();
    } else if (widget.onDecrement != null) {
      widget.onDecrement!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value < widget.minValue) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveHeight = widget.height ?? _CounterConstants.defaultHeight;
    final effectiveBorderRadius = widget.borderRadius ?? _CounterConstants.defaultBorderRadius;
    final effectiveIconSize = widget.iconSize ?? _CounterConstants.defaultIconSize;
    final effectiveBorderColor = widget.borderColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.2);
    final effectiveTextStyle = widget.textStyle ?? theme.textTheme.bodyLarge ?? const TextStyle();

    final canDecrement = widget.enabled && widget.value > widget.minValue;
    final canIncrement = widget.enabled && (widget.maxValue == null || widget.value < widget.maxValue!);

    return Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(color: effectiveBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CounterTapIcon(
            icon: Icons.remove,
            iconSize: effectiveIconSize,
            height: effectiveHeight,
            onPressed: canDecrement ? _onDecrementTap : null,
          ),
          if (widget.onValueChanged != null)
            SizedBox(
              width: _CounterConstants.fieldWidth,
              height: effectiveHeight,
              child: Center(
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  style: effectiveTextStyle.copyWith(height: 1.0),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: _onFieldChanged,
                ),
              ),
            )
          else
            SizedBox(
              height: effectiveHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    widget.value.toString(),
                    style: effectiveTextStyle,
                  ),
                ),
              ),
            ),
          _CounterTapIcon(
            icon: Icons.add,
            iconSize: effectiveIconSize,
            height: effectiveHeight,
            onPressed: canIncrement ? widget.onIncrement : null,
          ),
        ],
      ),
    );
  }
}

/// Зона тапа — весь доступный столбец [height] × половина ширины счётчика:
/// это даёт крупный hit‑target без необходимости тянуть пальцем в точный глиф.
class _CounterTapIcon extends StatelessWidget {
  const _CounterTapIcon({
    required this.icon,
    required this.iconSize,
    required this.height,
    this.onPressed,
  });

  final IconData icon;
  final double iconSize;
  final double height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;
    final color = enabled ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.38);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: height,
          height: height,
          child: Center(child: Icon(icon, size: iconSize, color: color)),
        ),
      ),
    );
  }
}
