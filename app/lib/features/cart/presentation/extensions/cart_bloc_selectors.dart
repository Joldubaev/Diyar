import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Расширения для удобного получения данных из CartBloc
extension CartBlocSelectors on BuildContext {
  /// Получает список товаров корзины реактивно
  /// Возвращает пустой список, если корзина еще не загружена
  List<CartItemEntity> get cartItems {
    return select<CartBloc, List<CartItemEntity>>(
      (bloc) => bloc.state is CartLoaded ? (bloc.state as CartLoaded).items : <CartItemEntity>[],
    );
  }
}
