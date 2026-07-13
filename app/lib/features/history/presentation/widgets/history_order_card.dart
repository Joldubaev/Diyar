import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

import 'pickup_order_status_badge.dart';

/// Строка «название — значение» в карточке заказа.
class HistoryCardRow {
  final String label;
  final String value;

  const HistoryCardRow({required this.label, required this.value});
}

/// Единая карточка заказа для всех экранов истории (доставка и самовывоз):
/// номер + бейдж статуса, дата, строки стоимости и кнопка «Подробнее».
class HistoryOrderCard extends StatelessWidget {
  final int? orderNumber;
  final String? status;

  /// Сырая дата заказа с бэкенда (`timeRequest`) — парсится внутри.
  final String? timeRequest;
  final List<HistoryCardRow> rows;
  final String detailsLabel;
  final VoidCallback onDetails;

  const HistoryOrderCard({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.timeRequest,
    required this.rows,
    required this.detailsLabel,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = timeRequest.parseOrderDateTime();

    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${context.l10n.orderNumber} $orderNumber',
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PickupOrderStatusBadge(status: status),
              ],
            ),
            if (date != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), thickness: 1),
            for (final row in rows) ...[
              CustomTile(title: row.label, trailing: row.value),
              const SizedBox(height: 4),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: CustomTextButton(
                onPressed: onDetails,
                textButton: detailsLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    final hasTime = date.hour != 0 || date.minute != 0;
    final day = '${two(date.day)}.${two(date.month)}.${date.year}';
    return hasTime ? '$day • ${two(date.hour)}:${two(date.minute)}' : day;
  }
}
