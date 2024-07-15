import 'package:diyar/features/order/order.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

enum PaymentTypeDelivery { cash, card, online }

class PaymentTypeSelector extends StatelessWidget {
  final PaymentTypeDelivery currentPaymentType;
  final ValueChanged<String> onSelected;

  const PaymentTypeSelector({
    Key? key,
    required this.currentPaymentType,
    required this.onSelected,
  }) : super(key: key);

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

  //  ElevatedButton(
  //               onPressed: () {},
  //               child: PopupMenuButton<String>(
  //                 onSelected: (String value) {
  //                   log('Selected: $value');
  //                   setState(() {
  //                     if (value == context.l10n.payWithCash) {
  //                       _paymentType = PaymentTypeDelivery.cash;
  //                     } else if (value == context.l10n.payWithCard) {
  //                       _paymentType = PaymentTypeDelivery.card;
  //                     } else if (value == context.l10n.payOnline) {
  //                       _paymentType = PaymentTypeDelivery.online;
  //                     }
  //                   });
  //                 },
  //                 itemBuilder: (BuildContext context) {
  //                   return [
  //                     context.l10n.payWithCash,
  //                     // 'Оплатить картой',
  //                     // 'Оплатить онлайн'
  //                   ].map((String choice) {
  //                     return PopupMenuItem<String>(
  //                         value: choice, child: Text(choice));
  //                   }).toList();
  //                 },
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     ClipRRect(
  //                         borderRadius: BorderRadius.circular(100),
  //                         child: const Icon(Icons.payment)),
  //                     Text(context.l10n.payWithCash),
  //                   ],
  //                 ),
  //               ),
  //             ),