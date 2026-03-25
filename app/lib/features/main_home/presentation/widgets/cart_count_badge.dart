import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

/// Бейдж с количеством товаров в корзине для FAB.
class CartCountBadge extends StatelessWidget {
  const CartCountBadge({super.key, required this.cartCount});

  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      child: Text(
        cartCount > 99 ? '99+' : '$cartCount',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.red,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
