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
          final cartItemFood = cartItem.food;
          final quantity = cartItem.quantity ?? 0;
          if (cartItemFood == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 10),
            child: CartItemWidget(
              counter: quantity,
              food: cartItemFood,
              onRemove: () {
                _showDeleteConfirmationDialog(context, cartItemFood);
              },
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    FoodEntity? food,
  ) async {
    final foodId = food?.id;
    if (foodId == null) return;

    final cartBloc = context.read<CartBloc>();
    final l10n = context.l10n;

    final confirmed = await DeleteConfirmationDialog.show(
      context: context,
      title: l10n.deleteOrder,
      message: l10n.deleteOrderText,
      cancelText: l10n.no,
      deleteText: l10n.yes,
    );

    if (confirmed == true && context.mounted) {
      cartBloc.add(RemoveItemFromCart(foodId));
    }
  }
}
