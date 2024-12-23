import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
