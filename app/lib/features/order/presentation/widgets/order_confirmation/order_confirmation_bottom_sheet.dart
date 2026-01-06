import 'package:diyar/features/order/presentation/widgets/order_confirmation/order_confirmation_actions.dart';
import 'package:diyar/features/order/presentation/widgets/order_confirmation/order_confirmation_details.dart';
import 'package:diyar/features/order/presentation/widgets/order_confirmation/order_confirmation_header.dart';
import 'package:flutter/material.dart';

/// Bottom sheet для подтверждения заказа
class OrderConfirmationBottomSheet extends StatelessWidget {
  final ThemeData theme;
  final int totalPrice;
  final int deliveryPrice;
  final int totalOrderCost;
  final VoidCallback onConfirmOrder;
  final VoidCallback onSaveTemplate;

  const OrderConfirmationBottomSheet({
    super.key,
    required this.theme,
    required this.totalPrice,
    required this.deliveryPrice,
    required this.totalOrderCost,
    required this.onConfirmOrder,
    required this.onSaveTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.35,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                OrderConfirmationHeader(theme: theme),
                const SizedBox(height: 15),
                OrderConfirmationDetails(
                  totalPrice: totalPrice,
                  deliveryPrice: deliveryPrice,
                  totalOrderCost: totalOrderCost,
                ),
                const Divider(),
                OrderConfirmationActions(
                  theme: theme,
                  onConfirmOrder: onConfirmOrder,
                  onSaveTemplate: onSaveTemplate,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

