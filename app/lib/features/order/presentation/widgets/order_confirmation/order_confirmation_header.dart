import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

/// Заголовок bottom sheet подтверждения заказа
class OrderConfirmationHeader extends StatelessWidget {
  final ThemeData theme;

  const OrderConfirmationHeader({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.orderConfirmation,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

