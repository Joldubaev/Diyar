import 'package:bloc/bloc.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
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

  Future<void> getDistricts({String? search}) async {
    emit(DistricLoading());
    try {
      final result = await _orderRepository.getDistricts(search: search);
      result.fold(
        (failure) {
          emit(DistricError(message: failure.message));
        },
        (districtEntities) {
          emit(DistricLoaded(districtEntities));
        },
      );
    } catch (e) {
      emit(DistricError(message: e.toString()));
    }
  }

  Future<void> createOrder(CreateOrderEntity orderEntity) async {
    emit(CreateOrderLoading());
    try {
      final result = await _orderRepository.createOrder(orderEntity);
      result.fold(
        (failure) => emit(CreateOrderError(failure.message)),
        (_) => emit(CreateOrderLoaded()),
      );
    } catch (e) {
      emit(CreateOrderError(e.toString()));
    }
  }
}
