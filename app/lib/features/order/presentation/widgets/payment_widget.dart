
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

enum PaymentTypeDelivery { cash, card, online }

class PaymentTypeSelector extends StatelessWidget {
  final PaymentTypeDelivery currentPaymentType;
  final ValueChanged<String> onSelected;

  const PaymentTypeSelector({
    super.key,
    required this.currentPaymentType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Способ оплаты', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            PaymentTypeOption(
              title: l10n.payWithCash,
              isSelected: currentPaymentType == PaymentTypeDelivery.cash,
              onSelected: onSelected,
            ),
            PaymentTypeOption(
              title: l10n.payWithCard,
              isSelected: currentPaymentType == PaymentTypeDelivery.card,
              onSelected: onSelected,
            ),
            PaymentTypeOption(
              title: l10n.payOnline,
              isSelected: currentPaymentType == PaymentTypeDelivery.online,
              onSelected: onSelected,
            ),
          ],
        ),
      ],
    );
  }
}