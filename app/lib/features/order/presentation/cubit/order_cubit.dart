import 'package:bloc/bloc.dart';
import '../../../features.dart';
import '../../data/models/distric_model.dart';
import 'package:equatable/equatable.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderCubit(this._orderRepository) : super(OrderInitial());

  String address = '';
  int deliveryPrice = 0;
  bool isAddressSearch = false;

  changeAddress(String str) {
    emit(OrderAddressLoading());
    address = str;
    emit(OrderAddressChanged(address: str));
  }

  changeAddressSearch(bool isSearch) {
    emit(OrderAddressLoading());
    isAddressSearch = isSearch;
    emit(OrderAddressLoading());
  }

  selectDeliveryPrice(double price) {
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

  Future createOrder(CreateOrderModel order) async {
    emit(CreateOrderLoading());
    try {
      await _orderRepository.createOrder(order);
      emit(CreateOrderLoaded());
    } catch (e) {
      emit(CreateOrderError());
    }
  }

  Future getPickupOrder(PickupOrderModel order) async {
    emit(CreateOrderLoading());
    try {
      await _orderRepository.getPickupOrder(order);
      emit(CreateOrderLoaded());
    } catch (e) {
      emit(CreateOrderError());
    }
  }
}
