import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class VersionWidgets extends StatelessWidget {
  const VersionWidgets({
    required this.leading,
    required this.title,
    super.key,
    this.onTap,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final void Function()? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_back_ios),
      iconColor: theme.colorScheme.primaryContainer,
      titleTextStyle: theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.secondaryContainer,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
