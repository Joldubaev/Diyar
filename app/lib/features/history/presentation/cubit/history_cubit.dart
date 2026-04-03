import 'package:diyar/core/bloc/base_cubit.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

@injectable
class HistoryCubit extends BaseCubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryInitial());

  final HistoryRepository _repository;

  Future<void> getHistoryOrders() {
    return handleEither(
      call: () => _repository.getHistoryOrders(),
      onLoading: () => const GetHistoryOrdersLoading(),
      onSuccess: (orders) => GetHistoryOrdersLoaded(orders),
      onFailure: (f) => GetHistoryOrdersError(f.message),
    );
  }

  Future<void> getPickupHistory({int pageNumber = 1, int pageSize = 10}) {
    return handleEither(
      call: () => _repository.getPickupHistory(pageNumber: pageNumber, pageSize: pageSize),
      onLoading: () => const GetPickupHistoryLoading(),
      onSuccess: (response) => GetPickupHistoryLoaded(response),
      onFailure: (f) => GetPickupHistoryError(f.message),
    );
  }
}
