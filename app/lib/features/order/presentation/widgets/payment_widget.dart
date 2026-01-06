import 'package:flutter/material.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';

class PaymentTypeSelector extends StatelessWidget {
  final PaymentTypeDelivery currentPaymentType;
  final ValueChanged<PaymentTypeDelivery> onChanged;

  const PaymentTypeSelector({
    super.key,
    required this.currentPaymentType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Способ оплаты', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            _PaymentTypeCard(
              icon: Icons.money,
              text: l10n.payWithCash,
              selected: currentPaymentType == PaymentTypeDelivery.cash,
              onTap: () => onChanged(PaymentTypeDelivery.cash),
            ),
            const SizedBox(width: 12),
            _PaymentTypeCard(
              icon: Icons.credit_card,
              text: l10n.payOnline,
              selected: currentPaymentType == PaymentTypeDelivery.online,
              onTap: () => onChanged(PaymentTypeDelivery.online),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentTypeCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTypeCard({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface.withValues(alpha: 0.1);
    final textColor = selected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8)] : [],
            border: Border.all(
              color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
