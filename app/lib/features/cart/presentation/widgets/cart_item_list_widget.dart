import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/menu.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemsListWidget extends StatelessWidget {
  final List<CartItemEntity> items;
  const CartItemsListWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cartItem = items[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 10),
            child: CartItemWidgets(
              counter: cartItem.quantity ?? 0,
              food: cartItem.food ?? FoodEntity(),
              onRemove: () {
                _showDeleteConfirmationDialog(context, cartItem.food);
              },
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, FoodEntity? food) async {
    if (food?.id == null) return;

    final cartBloc = context.read<CartBloc>();
    final l10n = context.l10n;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          title: Text(l10n.deleteOrder, textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
          content: Text(l10n.deleteOrderText, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                foregroundColor: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.no),
            ),
            const SizedBox(width: 12),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.errorContainer,
                foregroundColor: theme.colorScheme.onErrorContainer,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.yes),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      cartBloc.add(RemoveItemFromCart(food!.id!));
    }
  }
}
