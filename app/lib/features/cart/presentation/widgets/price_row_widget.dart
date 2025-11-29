import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class PriceRowWidget extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;
  final bool isTotal;

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium,
          ),
          Text(
            '${value.toStringAsFixed(0)} ${context.l10n.som}',
            style: (isTotal
                    ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                    : theme.textTheme.bodyMedium)
                ?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
