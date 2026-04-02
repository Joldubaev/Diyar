import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class ConfirmOrderCommentSection extends StatelessWidget {
  const ConfirmOrderCommentSection({
    super.key,
    required this.comment,
    required this.theme,
    required this.l10n,
  });

  final String comment;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.comment,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          comment,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
