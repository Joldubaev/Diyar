import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:diyar/core/components/components.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/pick_up/domain/entities/pickup_order_entity.dart';
import 'package:diyar/features/pick_up/domain/repositories/pick_up_repositories.dart';
import 'package:injectable/injectable.dart';

part 'pick_up_state.dart';

@injectable
class PickUpCubit extends Cubit<PickUpState> {
  final PickUpRepositories _pickUpRepository;

  PickUpCubit(this._pickUpRepository) : super(PickUpInitial());

  Future<void> submitPickupOrder(PickupOrderEntity order) async {
    emit(CreatePickUpOrderLoading());
    try {
      final result = await _pickUpRepository.getPickupOrder(order);
      result.fold(
        (failure) => emit(CreatePickUpOrderError(failure.message)),
        (entity) => emit(CreatePickUpOrderLoaded(entity)),
      );
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
    }
  }

  /// Создает заказ самовывоза из сырых данных формы
  Future<void> createPickupOrder({
    required List<CartItemEntity> cart,
    required String userName,
    required String phone,
    required String time,
    required String comment,
    required String paymentMethod,
    required int totalPrice,
    required int? dishCount,
    double? bonusAmount,
  }) async {
    emit(CreatePickUpOrderLoading());

    try {
      // Вычисляем dishesCount из cart
      final calculatedDishesCount = dishCount ?? cart.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));

      // Преобразуем cart в список FoodItemOrderEntity
      final foods = cart
          .map((cartItem) => FoodItemOrderEntity(
                dishId: '${cartItem.food?.id}',
                name: cartItem.food?.name ?? '',
                price: cartItem.food?.price ?? 0,
                quantity: cartItem.quantity ?? 1,
              ))
          .toList();

      // Создаем PickupOrderEntity
      final order = PickupOrderEntity(
        userName: userName.trim(),
        userPhone: phone.trim(),
        prepareFor: time.trim(),
        comment: comment.trim().isEmpty ? null : comment.trim(),
        paymentMethod: paymentMethod,
        price: totalPrice, // Полная сумма заказа
        dishesCount: calculatedDishesCount,
        amountToReduce: bonusAmount != null && bonusAmount > 0 ? bonusAmount : null, // Бонусы передаются отдельно
        foods: foods,
      );

      // Отправляем заказ
      final result = await _pickUpRepository.getPickupOrder(order);
      result.fold(
        (failure) => emit(CreatePickUpOrderError(failure.message)),
        (entity) => emit(CreatePickUpOrderLoaded(entity)),
      );
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
    }
  }
}
