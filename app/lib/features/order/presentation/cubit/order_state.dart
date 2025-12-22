part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderAddressLoading extends OrderState {}

class OrderAddressChanged extends OrderState {
  final String address;

  const OrderAddressChanged({required this.address});

  @override
  List<Object?> get props => [address];
}

class SelectDeliveryPriceLoading extends OrderState {}

class SelectDeliveryPriceLoaded extends OrderState {
  final double deliveryPrice;

  const SelectDeliveryPriceLoaded({required this.deliveryPrice});

  @override
  List<Object?> get props => [deliveryPrice];
}

class SelectDeliveryPriceError extends OrderState {
  final String message;
  const SelectDeliveryPriceError(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateOrderLoading extends OrderState {}

class CreateOrderLoaded extends OrderState {
  final String? res;
  const CreateOrderLoaded( this.res);

  @override
  List<Object?> get props => [res];
}

class CreateOrderError extends OrderState {
  final String message;
  const CreateOrderError(this.message);

  @override
  List<Object?> get props => [message];
}

class DistricLoading extends OrderState {}

class DistricLoaded extends OrderState {
  final List<DistrictEntity> districts;

  const DistricLoaded(this.districts);

  @override
  List<Object?> get props => [districts];
}

class DistricError extends OrderState {
  final String message;

  const DistricError({required this.message});

  @override
  List<Object?> get props => [message];
}
