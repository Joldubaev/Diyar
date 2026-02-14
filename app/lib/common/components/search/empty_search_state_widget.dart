import 'package:diyar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Виджет пустого состояния для поиска
class EmptySearchStateWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;

  const EmptySearchStateWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.search_off,
            size: 64,
            color: AppColors.grey3,
          ),
          const SizedBox(height: 16),
          if (title != null)
            Text(
              title!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.grey,
              ),
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
