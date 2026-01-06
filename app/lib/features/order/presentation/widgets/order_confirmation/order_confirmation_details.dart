import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/presentation/widgets/info_dialog_widget.dart';
import 'package:flutter/material.dart';

/// Детали заказа в bottom sheet подтверждения
class OrderConfirmationDetails extends StatelessWidget {
  final int totalPrice;
  final int deliveryPrice;
  final int totalOrderCost;

  const OrderConfirmationDetails({
    super.key,
    required this.totalPrice,
    required this.deliveryPrice,
    required this.totalOrderCost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoDialogWidget(
          title: context.l10n.orderAmount,
          description: '$totalPrice сом',
        ),
        InfoDialogWidget(
          title: context.l10n.deliveryCost,
          description: '$deliveryPrice сом',
        ),
        InfoDialogWidget(
          title: context.l10n.total,
          description: '$totalOrderCost сом',
        ),
      ],
    );
  }
}

