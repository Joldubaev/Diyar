import 'package:diyar/common/components/components.dart';
import 'package:flutter/material.dart';

/// Строка кнопок действий.
/// Если [onStartDelivery] задан — показывает "Забрал заказ" вместо "Завершить"
/// (заказ в статусе Cooked, курьер ещё не взял его).
class OrderActionsRowWidget extends StatelessWidget {
  final VoidCallback onDetails;
  final VoidCallback onFinish;
  final VoidCallback onOpenMap;
  final VoidCallback onCall;
  final VoidCallback? onStartDelivery;

  const OrderActionsRowWidget({
    super.key,
    required this.onDetails,
    required this.onFinish,
    required this.onOpenMap,
    required this.onCall,
    this.onStartDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final isPendingPickup = onStartDelivery != null;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ActionButtonWidget(
                onPressed: onDetails,
                icon: Icons.info_outline,
                label: 'Детали',
                variant: ActionButtonVariant.outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: isPendingPickup
                  ? ActionButtonWidget(
                      onPressed: onStartDelivery!,
                      icon: Icons.directions_bike_outlined,
                      label: 'Забрал заказ',
                      variant: ActionButtonVariant.primary,
                    )
                  : ActionButtonWidget(
                      onPressed: onFinish,
                      icon: Icons.check_circle_outline,
                      label: 'Завершить',
                      variant: ActionButtonVariant.primary,
                    ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActionButtonWidget(
                onPressed: onCall,
                icon: Icons.phone,
                label: 'Позвонить',
                variant: ActionButtonVariant.outlinedSuccess,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButtonWidget(
                onPressed: onOpenMap,
                icon: Icons.map_outlined,
                label: 'Карта',
                variant: ActionButtonVariant.outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
