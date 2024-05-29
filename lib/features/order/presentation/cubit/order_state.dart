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

class CreateOrderLoaded extends OrderState {}

class CreateOrderError extends OrderState {}
