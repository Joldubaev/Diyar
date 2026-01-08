import 'package:diyar/core/theme/theme_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:diyar/features/curier/curier.dart';

class CurierOrderCard extends StatelessWidget {
  final CurierEntity order;
  final VoidCallback onFinish;
  final VoidCallback onOpenMap;
  final VoidCallback onDetails;
  final VoidCallback onCall;

  const CurierOrderCard({
    super.key,
    required this.order,
    required this.onFinish,
    required this.onOpenMap,
    required this.onDetails,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    // Используем Card из темы, убираем лишние обертки
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2, // Чуть уменьшил для мягкости, как в современных картах
      child: ExpansionTile(
        // Убираем дефолтные границы ExpansionTile
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          'Заказ №${order.orderNumber ?? ""}',
          style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        children: [
          const Divider(),
          _OrderMainInfo(order: order),
          const SizedBox(height: 16),
          _OrderActionsRow(
            onDetails: onDetails,
            onFinish: onFinish,
            onOpenMap: onOpenMap,
          ),
        ],
      ),
    );
  }
}

// --- Внутренний виджет информации о заказе ---
class _OrderMainInfo extends StatelessWidget {
  final CurierEntity order;
  const _OrderMainInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    final totalPrice = (order.price ?? 0) + (order.deliveryPrice ?? 0);
    final address = '${order.address ?? ''} ${order.houseNumber ?? ''}'.trim();

    return Column(
      children: [
        Text(
          address,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Сумма заказа: $totalPrice сом',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// --- Внутренний виджет кнопок действий ---
class _OrderActionsRow extends StatelessWidget {
  final VoidCallback onDetails;
  final VoidCallback onFinish;
  final VoidCallback onOpenMap;

  const _OrderActionsRow({
    required this.onDetails,
    required this.onFinish,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Детали (второстепенное действие)
        Expanded(
          child: OutlinedButton(
            onPressed: onDetails,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 40),
            ),
            child: const Text('Детали'),
          ),
        ),
        const SizedBox(width: 8),
        // Завершить (главное действие)
        Expanded(
          child: ElevatedButton(
            onPressed: onFinish,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 40),
            ),
            child: const Text('Завершить'),
          ),
        ),
        const SizedBox(width: 8),
        // Карта (функциональное действие)
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onOpenMap,
            icon: const Icon(Icons.map_outlined, size: 16),
            label: const Text('Карта'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 40),
            ),
          ),
        ),
      ],
    );
  }
}
