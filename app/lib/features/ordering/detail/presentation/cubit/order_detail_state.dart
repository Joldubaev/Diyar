part of 'order_detail_cubit.dart';

sealed class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}

final class OrderDetailInitial extends OrderDetailState {
  const OrderDetailInitial();
}

final class OrderDetailLoading extends OrderDetailState {
  const OrderDetailLoading();
}

final class OrderDetailLoaded extends OrderDetailState {
  final OrderDetailEntity orderDetail;

  const OrderDetailLoaded(this.orderDetail);

  @override
  List<Object?> get props => [orderDetail];
}

final class OrderDetailError extends OrderDetailState {
  final String message;

  const OrderDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
