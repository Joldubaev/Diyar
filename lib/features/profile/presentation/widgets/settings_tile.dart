import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.leading,
    super.key,
  });

  final String text;
  final Color? color;
  final IconData? icon;
  final void Function()? onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          onTap: onPressed,
          hoverColor: Colors.black26,
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            icon ?? Icons.arrow_forward_ios,
            color: color ??
                Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
