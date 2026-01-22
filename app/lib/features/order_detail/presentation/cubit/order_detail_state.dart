part of 'order_detail_cubit.dart';

abstract class OrderDetailState {}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrderDetailEntity orderDetail;

  OrderDetailLoaded(this.orderDetail);
}

class OrderDetailError extends OrderDetailState {
  final String message;

  OrderDetailError(this.message);
}
