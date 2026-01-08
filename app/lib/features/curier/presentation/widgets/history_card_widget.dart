
import 'package:diyar/core/core.dart';
import 'package:diyar/core/theme/theme_extenstion.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';

import 'icon_info_row_widget.dart';

class HistoryCardWidget extends StatelessWidget {
  final CurierEntity order;
  const HistoryCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final total = (order.price ?? 0) + (order.deliveryPrice ?? 0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${context.l10n.orderNumber} ${order.orderNumber ?? ""}',
                    style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text(order.timeRequest?.split(' ')[0] ?? '', style: context.textTheme.bodySmall),
              ],
            ),
            const Divider(height: 24),
            IconInfoRowWidget(icon: Icons.person, label: context.l10n.name, value: order.userName ?? ''),
            const SizedBox(height: 8),
            IconInfoRowWidget(
                icon: Icons.place,
                label: context.l10n.addressD,
                value: '${order.address ?? ""} ${order.houseNumber ?? ""}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.l10n.totalAmount),
                Text('$total сом',
                    style:
                        context.textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
