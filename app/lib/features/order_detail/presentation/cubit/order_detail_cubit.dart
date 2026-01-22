import 'package:bloc/bloc.dart';
import 'package:diyar/features/order_detail/domain/domain.dart';
import 'package:injectable/injectable.dart';

part 'order_detail_state.dart';

@injectable
class OrderDetailCubit extends Cubit<OrderDetailState> {
  final GetOrderDetailUseCase _getOrderDetailUseCase;

  OrderDetailCubit(this._getOrderDetailUseCase) : super(OrderDetailInitial());

  Future<void> getOrderDetail({required int orderNumber}) async {
    emit(OrderDetailLoading());

    final result = await _getOrderDetailUseCase(orderNumber: orderNumber);

    result.fold(
      (failure) => emit(OrderDetailError(failure.message)),
      (orderDetail) => emit(OrderDetailLoaded(orderDetail)),
    );
  }
}
