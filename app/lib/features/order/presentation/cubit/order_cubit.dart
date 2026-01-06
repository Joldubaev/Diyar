import 'package:bloc/bloc.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:diyar/features/order/domain/usecases/create_order_usecase.dart';
import 'package:diyar/features/order/domain/usecases/get_districts_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'order_state.dart';

@injectable
class OrderCubit extends Cubit<OrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final GetDistrictsUseCase _getDistrictsUseCase;

  OrderCubit(
    this._createOrderUseCase,
    this._getDistrictsUseCase,
  ) : super(OrderInitial());

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

  Future<void> getDistricts({
    String? search,
    void Function(List<DistrictEntity>)? onSuccess,
    void Function(String)? onError,
  }) async {
    emit(DistricLoading());
    try {
      final result = await _getDistrictsUseCase(search: search);
      result.fold(
        (failure) {
          emit(DistricError(message: failure.message));
          onError?.call(failure.message);
        },
        (districtEntities) {
          emit(DistricLoaded(districtEntities));
          onSuccess?.call(districtEntities);
        },
      );
    } catch (e) {
      final errorMessage = e.toString();
      emit(DistricError(message: errorMessage));
      onError?.call(errorMessage);
    }
  }

  Future<void> createOrder(
    CreateOrderEntity orderEntity, {
    void Function(String?)? onSuccess,
    void Function(String)? onError,
  }) async {
    emit(CreateOrderLoading());
    try {
      final result = await _createOrderUseCase(orderEntity);
      result.fold(
        (failure) {
          emit(CreateOrderError(failure.message));
          onError?.call(failure.message);
        },
        (res) {
          emit(CreateOrderLoaded(res));
          onSuccess?.call(res);
        },
      );
    } catch (e) {
      final errorMessage = e.toString();
      emit(CreateOrderError(errorMessage));
      onError?.call(errorMessage);
    }
  }
}
