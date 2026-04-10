import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class ConfirmOrderSheetHeader extends StatelessWidget {
  const ConfirmOrderSheetHeader({
    super.key,
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.orderConfirmation,
          style: TextStyle(
            color: context.colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: context.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
