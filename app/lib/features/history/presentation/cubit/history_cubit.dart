import 'package:diyar/core/bloc/base_cubit.dart';
import 'package:diyar/core/utils/date_time_parser.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

@injectable
class HistoryCubit extends BaseCubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryInitial());

  final HistoryRepository _repository;

  /// Размер страницы при активном фильтре по дате: самовывоз пагинируется
  /// на сервере, поэтому для фильтрации грузим историю одной большой страницей.
  static const int filterPageSize = 100;

  List<OrderActiveItemEntity> _allHistoryOrders = const [];
  DateTimeRange? _historyDateRange;
  DateTimeRange? _pickupDateRange;

  Future<void> getHistoryOrders() {
    return handleEither(
      call: () => _repository.getHistoryOrders(),
      onLoading: () => const GetHistoryOrdersLoading(),
      onSuccess: (orders) {
        _allHistoryOrders = orders;
        return GetHistoryOrdersLoaded(
          _filterByDate(orders, (o) => o.timeRequest, _historyDateRange),
          dateRange: _historyDateRange,
        );
      },
      onFailure: (f) => GetHistoryOrdersError(f.message),
    );
  }

  /// Фильтр истории доставки по дате. Эндпоинт не пагинируется —
  /// фильтруем уже загруженный список без повторного запроса.
  void setHistoryDateFilter(DateTimeRange? range) {
    _historyDateRange = range;
    if (state is! GetHistoryOrdersLoaded) return;
    safeEmit(GetHistoryOrdersLoaded(
      _filterByDate(_allHistoryOrders, (o) => o.timeRequest, range),
      dateRange: range,
    ));
  }

  Future<void> getPickupHistory({int pageNumber = 1, int pageSize = 10}) {
    return handleEither(
      call: () => _repository.getPickupHistory(pageNumber: pageNumber, pageSize: pageSize),
      onLoading: () => const GetPickupHistoryLoading(),
      onSuccess: (response) {
        final range = _pickupDateRange;
        if (range == null) return GetPickupHistoryLoaded(response);
        // При активном фильтре ответ — одна большая страница: фильтруем её
        // и отключаем пагинацию.
        final filtered = _filterByDate(response.orders, (o) => o.timeRequest, range);
        return GetPickupHistoryLoaded(
          response.copyWith(orders: filtered, currentPage: 1, totalPages: 1),
          dateRange: range,
        );
      },
      onFailure: (f) => GetPickupHistoryError(f.message),
    );
  }

  /// Фильтр истории самовывоза по дате: перезагружает список одной
  /// страницей [filterPageSize] и фильтрует на клиенте; сброс фильтра
  /// возвращает обычную серверную пагинацию.
  Future<void> setPickupDateFilter(DateTimeRange? range) {
    _pickupDateRange = range;
    return getPickupHistory(pageSize: range == null ? 10 : filterPageSize);
  }

  List<T> _filterByDate<T>(
    List<T> orders,
    String? Function(T) dateOf,
    DateTimeRange? range,
  ) {
    if (range == null) return orders;
    return orders.where((order) {
      final date = dateOf(order).parseOrderDateTime();
      if (date == null) return false;
      return !date.isBefore(range.start) && !date.isAfter(range.end);
    }).toList();
  }
}
