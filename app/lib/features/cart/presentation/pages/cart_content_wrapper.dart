
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';

/// Универсальная обертка для контента корзины с автоматической обработкой состояний
/// Использует context.select для перерисовки только при изменении items
class CartContentWrapper extends StatelessWidget {
  final Widget Function(List<CartItemEntity> items) builder;
  final Widget Function()? onEmpty;
  final Widget Function()? onLoading;

  const CartContentWrapper({super.key, 
    required this.builder,
    this.onEmpty,
    this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    final items = context.cartItems;

    // Проверяем состояние загрузки
    final cartBloc = context.maybeRead<CartBloc>();
    final isCartLoading = cartBloc?.state is CartLoading;

    // Если корзина загружается, показываем skeleton
    if (isCartLoading && onLoading != null) {
      return onLoading!();
    }

    // Если корзина пуста, показываем пустое состояние
    if (items.isEmpty && onEmpty != null) {
      return onEmpty!();
    }

    // Если есть товары, показываем контент
    return builder(items);
  }
}
