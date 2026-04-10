import 'package:bloc/bloc.dart';
import 'package:diyar/features/ordering/detail/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'order_detail_state.dart';

@injectable
class OrderDetailCubit extends Cubit<OrderDetailState> {
  final OrderDetailRepository _repository;

  OrderDetailCubit(this._repository) : super(OrderDetailInitial());

  Future<void> getOrderDetail({required int orderNumber}) async {
    emit(OrderDetailLoading());

    final result = await _repository.getOrderDetail(orderNumber: orderNumber);

    result.fold(
      (failure) => emit(OrderDetailError(failure.message)),
      (orderDetail) => emit(OrderDetailLoaded(orderDetail)),
    );
  }
}
