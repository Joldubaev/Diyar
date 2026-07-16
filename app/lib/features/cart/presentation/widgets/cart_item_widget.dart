import 'package:diyar/common/food_card/export.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/cart/presentation/widgets/cart_food_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет для отображения позиции корзины.
///
/// Гарнир показывается строкой-модификатором под названием блюда
/// («+ Рис · 45 сом»), цена карточки — полная цена позиции (блюдо + гарнир),
/// счётчик один на позицию — как в привычных приложениях доставки.
///
/// Удаление происходит при уменьшении счётчика до 0 → [onRemove]
/// (показывает диалог подтверждения). Отдельной кнопки удаления нет.
class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final void Function() onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final food = item.food;
    if (food == null) return const SizedBox.shrink();
    final garnish = item.garnish;

    String? garnishLabel;
    if (garnish != null) {
      final garnishName = garnish.name ?? 'Гарнир';
      garnishLabel = (garnish.price ?? 0) > 0
          ? '+ $garnishName · ${FoodPriceFormatter.formatPriceWithCurrency(garnish.price)}'
          : '+ $garnishName';
    }

    return CartFoodCard(
      food: food,
      counter: item.quantity ?? 0,
      subtitle: garnishLabel,
      garnishPrice: garnish?.price,
      onIncrement: () {
        final rowKey = item.rowKey;
        if (rowKey != null) {
          context.read<CartBloc>().add(IncrementItemQuantity(rowKey));
        }
      },
      onDecrement: () {
        final rowKey = item.rowKey;
        if (rowKey != null) {
          context.read<CartBloc>().add(DecrementItemQuantity(rowKey));
        }
      },
      onMinReached: onRemove,
    );
  }
}
