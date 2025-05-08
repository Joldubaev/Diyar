import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final ThemeData theme;
  final String? address;
  final VoidCallback? onTap;

  const AddressCard({
    super.key,
    required this.theme,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.colorScheme.primary,
      child: ListTile(
        title: Text(
          address ?? context.l10n.addressIsNotFounded,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onTertiaryFixed,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onTertiaryFixed),
        onTap: onTap,
      ),
    );
  }
}
