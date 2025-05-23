import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:diyar/features/payments/presentation/widgets/payment_method_tile_widget.dart';
import 'package:diyar/l10n/l10n.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final int totalPrice;
  final Function(PaymentTypeDelivery) onPaymentTypeSelected;

  const PaymentMethodBottomSheet({
    super.key,
    required this.totalPrice,
    required this.onPaymentTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'confirmOrder',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          PaymentMethodTileWidget(
            icon: const Icon(Icons.money, size: 24),
            title: l10n.payWithCash,
            onTap: () {
              Navigator.of(context).pop();
              onPaymentTypeSelected(PaymentTypeDelivery.cash);
            },
          ),
          PaymentMethodTileWidget(
            icon: const Icon(Icons.credit_card, size: 24),
            title: l10n.payOnline,
            onTap: () {
              Navigator.of(context).pop();
              onPaymentTypeSelected(PaymentTypeDelivery.online);
            },
          ),
        ],
      ),
    );
  }
}
