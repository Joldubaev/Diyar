import 'package:diyar/common/components/components.dart';
import 'package:diyar/features/cart/cart.dart';
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
          if (cartItem.food == null) {
            return const SizedBox.shrink();
          }
          final isLast = index == items.length - 1;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CartItemWidget(
                item: cartItem,
                onRemove: () {
                  _showDeleteConfirmationDialog(context, cartItem);
                },
              ),
              if (!isLast) const Divider(height: 1, thickness: 0.5, indent: 76),
            ],
          );
        },
        childCount: items.length,
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    CartItemEntity item,
  ) async {
    final rowKey = item.rowKey;
    if (rowKey == null) return;

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
      cartBloc.add(RemoveItemFromCart(rowKey));
    }
  }
}
