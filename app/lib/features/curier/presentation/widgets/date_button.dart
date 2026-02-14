
import 'package:diyar/core/theme/app_colors.dart';
import 'package:diyar/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateBotton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const DateBotton({super.key, required this.label, this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: hasDate ? AppColors.primary : context.theme.dividerColor),
            borderRadius: BorderRadius.circular(8),
            color: hasDate ? AppColors.primary.withValues(alpha: 0.05) : null,
          ),
          child: Row(
            children: [
              Text('$label: ', style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  hasDate ? DateFormat('dd.MM.yyyy').format(date!) : 'ДД.ММ.ГГГГ',
                  style: context.textTheme.bodySmall?.copyWith(color: hasDate ? AppColors.primary : null),
                ),
              ),
              Icon(Icons.calendar_month, size: 14, color: hasDate ? AppColors.primary : context.theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }
}
