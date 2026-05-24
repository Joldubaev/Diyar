import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final GetUserEntity user;

  const DrawerHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
            child: SvgPicture.asset(
              'assets/icons/profile_icon.svg',
              height: 30,
              colorFilter: ColorFilter.mode(
                colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.userName ?? 'Курьер',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  user.phone ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.85),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
