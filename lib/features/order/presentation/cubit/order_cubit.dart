import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/order/data/models/create_payment_model.dart';
import 'package:diyar/features/order/data/models/distric_model.dart';
import 'package:equatable/equatable.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderCubit(this._orderRepository) : super(OrderInitial());

  String address = '';
  int deliveryPrice = 0;
  bool isAddressSearch = false;

  void changeAddress(String str) {
    emit(OrderAddressLoading());
    address = str;
    emit(OrderAddressChanged(address: str));
  }

  void changeAddressSearch(bool isSearch) {
    emit(OrderAddressLoading());
    isAddressSearch = isSearch;
    emit(OrderAddressLoading());
  }

  void selectDeliveryPrice(double price) {
    emit(SelectDeliveryPriceLoading());
    deliveryPrice = price.toInt();
    emit(SelectDeliveryPriceLoaded(deliveryPrice: price));
  }

  Future<List<DistricModel>?> getDistricts({String? search}) async {
    emit(DistricLoading());
    try {
      final result = await _orderRepository.getDistricts(search: search);
      return result.fold(
        (error) {
          emit(DistricError(message: error.message));
          return null;
        },
        (districts) {
          emit(DistricLoaded(districts));
          return districts;
        },
      );
    } catch (e) {
      emit(DistricError(message: e.toString()));
      return null;
    }
  }

  Future<Either<Failure, String>> createOrder(CreateOrderModel order) async {
    emit(CreateOrderLoading());
    try {
      final result = await _orderRepository.createOrder(order);
      result.fold(
        (failure) {
          log("❌ Ошибка создания заказа: ${failure.message}");
          emit(CreateOrderError());
        },
        (orderNumber) {
          log("✅ Заказ успешно создан. Номер: $orderNumber");
          emit(CreateOrderLoaded(orderNumber));
        },
      );
      return result; // 🔥 Возвращаем результат, а не void
    } catch (e, stackTrace) {
      log("❌ [ERROR] Ошибка при создании заказа: $e",
          error: e, stackTrace: stackTrace);
      emit(CreateOrderError());
      return Left(
          ServerFailure("Ошибка при создании заказа")); // 🔥 Возвращаем ошибку
    }
  }

  Future<void> getPickupOrder(PickupOrderModel order) async {
    emit(CreateOrderLoading());
    try {
      final result = await _orderRepository.getPickupOrder(order);
      result.fold(
        (failure) {
          log("❌ Ошибка при самовывозе: ${failure.message}");
          emit(CreateOrderError());
        },
        (_) {
          log("✅ Самовывоз успешно создан.");
          emit(CreateOrderSuccess()); // Теперь просто показываем успех
        },
      );
    } catch (e) {
      log("❌ Ошибка при самовывозе: $e");
      emit(CreateOrderError());
    }
  }

  Future<Either<Failure, String>> getPayment(PaymentModel order) async {
    emit(GetPaymentLoading());
    try {
      final result = await _orderRepository.getPaymnent(order);

      return result.fold(
        (failure) {
          log("❌ Ошибка при получении платежа: ${failure.message}");
          emit(GetPaymentError());
          return Left(failure);
        },
        (paymentUrl) {
          log("✅ Платеж успешно создан. URL: $paymentUrl");
          emit(GetPaymentSuccess(paymentUrl));
          return Right(paymentUrl);
        },
      );
    } catch (e) {
      log("❌ Ошибка при оплате: $e");
      emit(GetPaymentError());
      return Left(ServerFailure("Ошибка при оплате"));
    }
  }
}
