import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppEmptyWidget extends StatelessWidget {
  final String? svgAsset;
  final IconData? icon;
  final String title;
  final String? subtitle;

  const AppEmptyWidget({
    super.key,
    this.svgAsset,
    this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgAsset != null)
              SvgPicture.asset(svgAsset!, width: 200, height: 200),
            if (icon != null && svgAsset == null)
              Icon(icon, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
