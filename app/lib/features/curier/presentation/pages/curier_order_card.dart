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
    final theme = Theme.of(context);
    final totalPrice = (order.price ?? 0) + (order.deliveryPrice ?? 0);
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 4,
      child: ExpansionTile(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        title: Text(
          'Заказ №${order.orderNumber}',
          style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.address.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Сумма заказа $totalPrice сом',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.phone),
                  label: const Text('Позвонить'),
                ),
              ],
            ),
          ),
          Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), thickness: 1),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: onDetails,
                    child: Text('Детали'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: onFinish,
                    child: Text('Завершить'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: onOpenMap,
                    child: Text('На карте'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
