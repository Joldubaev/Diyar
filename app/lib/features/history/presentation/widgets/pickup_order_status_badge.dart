import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

/// Бейдж для отображения статуса заказа самовывоза
class PickupOrderStatusBadge extends StatelessWidget {
  final String? status;

  const PickupOrderStatusBadge({
    super.key,
    required this.status,
  });

  String _getStatusText(String? status) {
    switch (status) {
      case 'UnPaid':
        return 'Не оплачен';
      case 'Awaits':
        return 'Ожидает';
      case 'Processing':
        return 'Готовится';
      case 'Cooked':
        return 'Готов';
      case 'OnTheWay':
        return 'В пути';
      case 'Delivered':
        return 'Доставлен';
      case 'Finished':
        return 'Завершен';
      case 'Cancel':
        return 'Отменен';
      default:
        return status ?? 'Неизвестно';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'UnPaid':
        return AppColors.red;
      case 'Awaits':
        return AppColors.orange;
      case 'Processing':
        return AppColors.blue;
      case 'Cooked':
        return AppColors.yellow;
      case 'OnTheWay':
        return AppColors.info;
      case 'Delivered':
        return AppColors.green;
      case 'Finished':
        return AppColors.green;
      case 'Cancel':
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == null || status!.isEmpty) {
      return const SizedBox.shrink();
    }

    final statusText = _getStatusText(status);
    final statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }
}
