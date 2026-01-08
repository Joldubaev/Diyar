import 'package:bloc/bloc.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/domain/domain.dart';
import 'package:injectable/injectable.dart';

part 'curier_state.dart';

@injectable
class CurierCubit extends Cubit<CurierState> {
  CurierCubit(this._repository) : super(const UserInitial());

  final CurierRepository _repository;

  Future<void> getUser() async {
    emit(const UserLoading());

    final result = await _repository.getUser();
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> getCurierOrders() async {
    final user = state.user;
    if (user == null) return;

    emit(OrdersLoading(user: user));

    final result = await _repository.getCurierOrders();
    result.fold(
      (failure) => emit(OrdersError(message: failure.message, user: user)),
      (orders) => emit(OrdersLoaded(user: user, orders: orders)),
    );
  }

  Future<void> getFinishOrder(int orderId) async {
    final user = state.user;
    if (user == null) return;

    emit(FinishOrderLoading(user: user));

    final result = await _repository.getFinishOrder(orderId);
    result.fold(
      (failure) => emit(FinishOrderError(message: failure.message, user: user)),
      (_) => emit(FinishOrderSuccess(user: user)),
    );
  }

  Future<void> getCurierHistory({
    String? startDate,
    String? endDate,
    bool loadMore = false,
  }) async {
    final user = state.user;
    if (user == null) return;

    final currentState = state;
    final currentPage = currentState is CurierHistoryLoaded ? currentState.currentPage : 0;
    final existingOrders = currentState is CurierHistoryLoaded ? currentState.orders : <CurierEntity>[];

    if (loadMore && currentState is CurierHistoryLoaded) {
      emit(CurierHistoryLoadingMore(user: user, orders: existingOrders, currentPage: currentPage));
    } else {
      emit(CurierHistoryLoading(user: user));
    }

    final nextPage = loadMore ? currentPage + 1 : 1;
    final result = await _repository.getCurierHistory(
      startDate: startDate,
      endDate: endDate,
      page: nextPage,
      pageSize: 10,
    );
    result.fold(
      (failure) => emit(CurierHistoryError(message: failure.message, user: user)),
      (newOrders) {
        final allOrders = loadMore ? [...existingOrders, ...newOrders] : newOrders;
        final sortedOrders = _sortOrdersByDate(allOrders);
        final hasMore = newOrders.length >= 10;
        emit(CurierHistoryLoaded(
          user: user,
          orders: sortedOrders,
          hasMore: hasMore,
          currentPage: nextPage,
        ));
      },
    );
  }

  List<CurierEntity> _sortOrdersByDate(List<CurierEntity> orders) {
    return List.from(orders)
      ..sort((a, b) {
        final dateA = _parseDateTime(a.timeRequest);
        final dateB = _parseDateTime(b.timeRequest);

        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        return dateB.compareTo(dateA);
      });
  }

  DateTime? _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;

    try {
      final trimmed = dateTimeStr.trim();
      final parts = trimmed.split(' ');
      final datePart = parts[0];

      DateTime? date;

      if (datePart.contains('.')) {
        final dateParts = datePart.split('.');
        if (dateParts.length == 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          date = DateTime(year, month, day);
        }
      } else if (datePart.contains('/')) {
        final dateParts = datePart.split('/');
        if (dateParts.length == 3) {
          final month = int.parse(dateParts[0]);
          final day = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          date = DateTime(year, month, day);
        }
      } else if (datePart.contains('-')) {
        final dateParts = datePart.split('-');
        if (dateParts.length == 3) {
          final year = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final day = int.parse(dateParts[2]);
          date = DateTime(year, month, day);
        }
      }

      if (date == null) return null;

      if (parts.length > 1) {
        final timeParts = parts[1].split(':');
        if (timeParts.isNotEmpty) {
          final hour = int.parse(timeParts[0]);
          final minute = timeParts.length >= 2 ? int.parse(timeParts[1]) : 0;
          final second = timeParts.length >= 3 ? int.parse(timeParts[2]) : 0;
          date = DateTime(date.year, date.month, date.day, hour, minute, second);
        }
      }

      return date;
    } catch (e) {
      return null;
    }
  }
}
