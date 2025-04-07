part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderAddressLoading extends OrderState {}

class OrderAddressChanged extends OrderState {
  final String address;

  const OrderAddressChanged({required this.address});

  @override
  List<Object> get props => [address];
}

class SelectDeliveryPriceLoading extends OrderState {}

class SelectDeliveryPriceLoaded extends OrderState {
  final double deliveryPrice;

  const SelectDeliveryPriceLoaded({required this.deliveryPrice});

  @override
  List<Object> get props => [deliveryPrice];
}

class SelectDeliveryPriceError extends OrderState {}

class CreateOrderLoading extends OrderState {}

class CreateOrderLoaded extends OrderState {
  final String orderNumber;
  const CreateOrderLoaded(this.orderNumber);

  @override
  List<Object> get props => [orderNumber];
}

class CreateOrderSuccess extends OrderState {} // Добавлен успех без orderNumber

class CreateOrderError extends OrderState {}

class DistricLoading extends OrderState {}

class DistricLoaded extends OrderState {
  final List<DistricModel> districts; // Теперь это список

  const DistricLoaded(this.districts);

  @override
  List<Object> get props => [districts];
}

class DistricError extends OrderState {
  final String message;

  const DistricError({required this.message});
}

class GetPaymentLoading extends OrderState {}

class GetPaymentSuccess extends OrderState {
  final String url;
  const GetPaymentSuccess(this.url);
  @override
  List<Object> get props => [url];
} // Добавлен успех для платежа

class GetPaymentError extends OrderState {}
