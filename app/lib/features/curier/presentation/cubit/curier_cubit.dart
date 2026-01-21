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
      (user) {
        // После загрузки пользователя создаем CurierMainState
        emit(CurierMainState(user: user));
      },
    );
  }

  /// Загружает активные заказы (не перетирает историю)
  Future<void> getCurierOrders() async {
    final user = state.user;
    if (user == null) return;

    // Если состояние не CurierMainState, создаем его
    final currentState = state is CurierMainState ? state as CurierMainState : CurierMainState(user: user);

    emit(currentState.copyWith(isActiveOrdersLoading: true, clearActiveOrdersError: true));

    final result = await _repository.getCurierOrders();
    result.fold(
      (failure) => emit(currentState.copyWith(
        isActiveOrdersLoading: false,
        activeOrdersError: failure.message,
      )),
      (orders) => emit(currentState.copyWith(
        isActiveOrdersLoading: false,
        activeOrders: orders,
        clearActiveOrdersError: true,
      )),
    );
  }

  /// Загружает историю заказов (не перетирает активные заказы)
  Future<void> getCurierHistory({
    String? startDate,
    String? endDate,
    bool loadMore = false,
  }) async {
    final user = state.user;
    if (user == null) return;

    // Если состояние не CurierMainState, создаем его
    final currentState = state is CurierMainState ? state as CurierMainState : CurierMainState(user: user);

    final currentPage = loadMore ? currentState.historyCurrentPage : 0;
    final existingOrders = loadMore ? currentState.historyOrders : <CurierEntity>[];

    emit(currentState.copyWith(
      isHistoryLoading: !loadMore,
      isHistoryLoadingMore: loadMore,
      clearHistoryError: true,
    ));

    final nextPage = loadMore ? currentPage + 1 : 1;
    final result = await _repository.getCurierHistory(
      startDate: startDate,
      endDate: endDate,
      page: nextPage,
      pageSize: 10,
    );
    result.fold(
      (failure) => emit(currentState.copyWith(
        isHistoryLoading: false,
        isHistoryLoadingMore: false,
        historyError: failure.message,
      )),
      (newOrders) {
        final allOrders = loadMore ? [...existingOrders, ...newOrders] : newOrders;
        final sortedOrders = _sortOrdersByDate(allOrders);
        final hasMore = newOrders.length >= 10;
        emit(currentState.copyWith(
          isHistoryLoading: false,
          isHistoryLoadingMore: false,
          historyOrders: sortedOrders,
          historyHasMore: hasMore,
          historyCurrentPage: nextPage,
          clearHistoryError: true,
        ));
      },
    );
  }

  Future<void> getFinishOrder(int orderId) async {
    final user = state.user;
    if (user == null) return;

    // Сохраняем текущее состояние перед операцией
    final currentMainState = state is CurierMainState ? state as CurierMainState : null;

    emit(FinishOrderLoading(user: user));

    final result = await _repository.getFinishOrder(orderId);
    result.fold(
      (failure) {
        // Восстанавливаем состояние с ошибкой
        if (currentMainState != null) {
          emit(currentMainState.copyWith(activeOrdersError: failure.message));
        } else {
          emit(FinishOrderError(message: failure.message, user: user));
        }
      },
      (_) {
        // Восстанавливаем состояние и перезагружаем активные заказы
        if (currentMainState != null) {
          emit(currentMainState);
          getCurierOrders();
        } else {
          emit(FinishOrderSuccess(user: user));
        }
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
