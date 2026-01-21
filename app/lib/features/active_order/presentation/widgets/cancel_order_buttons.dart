import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelOrderButton extends StatelessWidget {
  final OrderActiveItemEntity order;
  const CancelOrderButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Проверка условий из документации: кнопка только при статусах Awaits или UnPaid
    final canCancel = order.status == 'Awaits' || order.status == 'UnPaid';

    if (!canCancel) return const SizedBox.shrink();

    return OutlinedButton(
      onPressed: () => _showConfirmDialog(context),
      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
      child: const Text('Отменить'),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    AppAlert.showConfirmDialog(
      context: context,
      title: 'Отмена заказа',
      content: Text('Вы уверены, что хотите отменить заказ №${order.orderNumber}?'),
      confirmPressed: () {
        Navigator.of(context).pop();
        context.read<ActiveOrderCubit>().cancelOrder(order);
      },
      confirmIsDestructive: true,
      confirmText: 'Отменить',
      cancelText: 'Нет',
    );
  }
}
