import 'package:diyar/core/components/models/food_item_order_entity.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/pick_up/domain/entities/pickup_order_entity.dart';
import 'package:injectable/injectable.dart';

/// Use case для создания PickupOrderEntity из данных корзины и формы
@injectable
class CreatePickupOrderFromCartUseCase {
  PickupOrderEntity call({
    required List<CartItemEntity> cartItems,
    required String userName,
    required String userPhone,
    required String prepareFor,
    required String? comment,
    required String paymentMethod,
    required int totalPrice,
    required int dishCount,
  }) {
    final foods = cartItems
        .map((cartItem) => FoodItemOrderEntity(
              dishId: cartItem.food?.id ?? '',
              name: cartItem.food?.name ?? '',
              price: cartItem.food?.price ?? 0,
              quantity: cartItem.quantity ?? 1,
            ))
        .toList();

    return PickupOrderEntity(
      userName: userName,
      userPhone: userPhone,
      prepareFor: prepareFor,
      comment: comment,
      paymentMethod: paymentMethod,
      price: totalPrice,
      dishesCount: dishCount,
      foods: foods,
    );
  }
}

