import '../../../../l10n/l10n.dart';
import 'package:flutter/material.dart';

class DeliveryPriceInfo extends StatelessWidget {
  final double deliveryPrice;
  final ThemeData theme;

  const DeliveryPriceInfo({
    super.key,
    required this.deliveryPrice,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: theme.colorScheme.error,
        border: Border.all(color: theme.colorScheme.onSurface),
      ),
      child: Text(
        '${context.l10n.deliveryPrice}: ${deliveryPrice.toStringAsFixed(2)} сом',
        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.surface),
      ),
    );
  }
}