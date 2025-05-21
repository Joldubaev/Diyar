import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ContactTileWidget extends StatelessWidget {
  const ContactTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SettingsTile(
        leading: const Icon(Icons.phone),
        text: l10n.contact,
        onPressed: () => context.router.push(const ContactRoute()),
      ),
    );
  }
}