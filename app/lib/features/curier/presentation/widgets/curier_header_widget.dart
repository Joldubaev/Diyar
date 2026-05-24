import 'package:diyar/core/theme/app_colors.dart';
import 'package:diyar/features/curier/domain/entities/get_user_entity.dart';
import 'package:flutter/material.dart';

class CurierHeaderWidget extends StatelessWidget {
  const CurierHeaderWidget({
    super.key,
    required this.user,
    required this.onMenuTap,
  });

  final GetUserEntity user;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final name = user.userName ?? '';
    final initials = _initials(name);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: primary.withValues(alpha: 0.15),
            child: Text(
              initials,
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Здравствуйте',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                ),
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Меню',
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      final w = parts.first;
      return w.substring(0, w.length.clamp(0, 2)).toUpperCase();
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}
