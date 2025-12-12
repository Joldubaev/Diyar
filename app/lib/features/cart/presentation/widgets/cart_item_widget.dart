import 'package:diyar/common/counter/export.dart';
import 'package:diyar/common/food_card/export.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

/// Виджет для отображения товара в корзине
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
    final theme = Theme.of(context);

    return FoodCardWidget.fromFoodEntity(
      food,
      trailing: IconButton(
        onPressed: onRemove,
        splashRadius: 20,
        visualDensity: VisualDensity.compact,
        icon: SvgPicture.asset(
          'assets/icons/delete.svg',
          colorFilter: ColorFilter.mode(
            theme.colorScheme.error,
            BlendMode.srcIn,
          ),
        ),
      ),
      bottom: CounterWidget(
        value: counter,
        onIncrement: () {
          final foodId = food.id;
          if (foodId != null && foodId.isNotEmpty) {
            context.read<CartBloc>().add(IncrementItemQuantity(foodId));
          }
        },
        onDecrement: () {
          final foodId = food.id;
          if (foodId != null && foodId.isNotEmpty) {
            if (counter > 1) {
              context.read<CartBloc>().add(DecrementItemQuantity(foodId));
            }
          }
        },
        onMinReached: () {
          final foodId = food.id;
          if (foodId != null && foodId.isNotEmpty) {
            context.read<CartBloc>().add(RemoveItemFromCart(foodId));
          }
        },
      ),
    );
  }
}
