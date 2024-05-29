import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class ActiveTile extends StatelessWidget {
  const ActiveTile({
    required this.text,
    this.hasNotification = false,
    this.onPressed,
    super.key,
  });

  final String text;
  final bool hasNotification;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: theme.colorScheme.surface,
      child: ListTile(
        onTap: onPressed,
        contentPadding: const EdgeInsets.fromLTRB(10, 4, 6, 2),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(text,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'В процессе',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
