import 'package:diyar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Базовый виджет элемента результата поиска
class SearchResultItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const SearchResultItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconBgColor = iconBackgroundColor ?? theme.colorScheme.primary.withValues(alpha: 0.1);
    final iconFgColor = iconColor ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.grey1,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Иконка
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon ?? Icons.location_on,
                  color: iconFgColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Текст
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Стрелка
              Icon(
                Icons.chevron_right,
                color: AppColors.grey3,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
