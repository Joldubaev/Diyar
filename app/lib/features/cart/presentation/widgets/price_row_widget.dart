import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class PriceRowWidget extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;
  final bool isTotal;

  static const double _verticalPadding = 4.0;

  const PriceRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle =
        isTotal ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(
            '${value.toStringAsFixed(0)} ${context.l10n.som}',
            style: textStyle?.copyWith(
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
