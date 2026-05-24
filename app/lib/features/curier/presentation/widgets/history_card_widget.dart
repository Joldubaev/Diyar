import 'package:diyar/core/core.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';

class HistoryCardWidget extends StatelessWidget {
  final CurierEntity order;
  const HistoryCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = (order.price ?? 0) + (order.deliveryPrice ?? 0);
    final address = '${order.address ?? ''} ${order.houseNumber ?? ''}'.trim();
    final dateStr = order.timeRequest?.split(' ')[0] ?? '';
    final name = order.userName ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${context.l10n.orderNumber} ${order.orderNumber ?? ""}',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dateStr,
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          if (name.isNotEmpty) ...[
            _InfoRow(icon: Icons.person_outline_rounded, text: name),
            const SizedBox(height: 6),
          ],
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: address.isNotEmpty ? address : '—',
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.totalAmount,
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.grey),
              ),
              Text(
                '$total сом',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
