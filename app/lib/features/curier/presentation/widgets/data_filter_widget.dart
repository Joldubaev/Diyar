import 'package:diyar/core/theme/theme_extenstion.dart';
import 'package:flutter/material.dart';

import 'date_button.dart';

class DateFiltersSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function({required bool isStart}) onPick;

  const DateFiltersSection({super.key, this.startDate, this.endDate, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(bottom: BorderSide(color: context.theme.dividerColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          DateBotton(label: 'С', date: startDate, onTap: () => onPick(isStart: true)),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('—')),
          DateBotton(label: 'По', date: endDate, onTap: () => onPick(isStart: false)),
        ],
      ),
    );
  }
}