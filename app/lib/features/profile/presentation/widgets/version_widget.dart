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
      iconColor: Theme.of(context).colorScheme.primaryContainer,
      titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
