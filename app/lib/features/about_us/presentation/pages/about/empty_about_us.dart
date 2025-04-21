import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EmptyAboutUsWidget extends StatelessWidget {
  const EmptyAboutUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          context.l10n.emptyText,
          style: TextStyle(
              fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
