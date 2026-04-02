part of 'order_detail_cubit.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}

class OrderDetailInitial extends OrderDetailState {
  const OrderDetailInitial();
}

class OrderDetailLoading extends OrderDetailState {
  const OrderDetailLoading();
}

class OrderDetailLoaded extends OrderDetailState {
  final OrderDetailEntity orderDetail;

  const OrderDetailLoaded(this.orderDetail);

  @override
  List<Object?> get props => [orderDetail];
}

class OrderDetailError extends OrderDetailState {
  final String message;

  const OrderDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
