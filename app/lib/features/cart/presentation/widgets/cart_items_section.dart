import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';

/// Секция со списком товаров в корзине
class CartItemsSection extends StatelessWidget {
  final List<CartItemEntity> items;

  const CartItemsSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CartItemsListWidget(items: items);
  }
}
