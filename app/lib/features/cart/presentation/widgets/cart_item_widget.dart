import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/cart/presentation/widgets/cart_food_card.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет для отображения товара в корзине.
///
/// Удаление происходит при уменьшении счётчика до 0 → [onRemove]
/// (показывает диалог подтверждения). Отдельной кнопки удаления нет.
class CartItemWidget extends StatelessWidget {
  final FoodEntity food;
  final int counter;
  final void Function() onRemove;

  const CartItemWidget({
    super.key,
    required this.food,
    required this.counter,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return CartFoodCard(
      food: food,
      counter: counter,
      onIncrement: () {
        final foodId = food.id;
        if (foodId != null && foodId.isNotEmpty) {
          context.read<CartBloc>().add(IncrementItemQuantity(foodId));
        }
      },
      onDecrement: () {
        final foodId = food.id;
        if (foodId != null && foodId.isNotEmpty) {
          context.read<CartBloc>().add(DecrementItemQuantity(foodId));
        }
      },
      onMinReached: onRemove,
    );
  }
}
