import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/theme/theme_extenstion.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../widgets/data_filter_widget.dart';
import '../widgets/history_card_widget.dart';
import '../widgets/state_widgets.dart';

@RoutePage()
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.orderHistory, style: context.textTheme.titleSmall),
        actions: [
          if (_startDate != null || _endDate != null)
            IconButton(icon: const Icon(Icons.clear_all), onPressed: _clearFilters),
        ],
      ),
      body: Column(
        children: [
          // Виджет фильтров
          DateFiltersSection(
            startDate: _startDate,
            endDate: _endDate,
            onPick: _showPicker,
          ),
          // Виджет списка
          Expanded(
            child: BlocConsumer<CurierCubit, CurierState>(
              listener: (context, state) {
                if (state is CurierHistoryError) context.showSnack(state.message, isError: true);
              },
              builder: (context, state) {
                return switch (state) {
                  CurierHistoryLoading() => context.loadingIndicator,
                  CurierHistoryError(:final message) => context.errorState(message),
                  CurierHistoryLoaded(:final orders, :final hasMore) => orders.isEmpty
                      ? context.emptyState(icon: Icons.history, message: context.l10n.noOrders)
                      : RefreshIndicator(
                          onRefresh: () async => _loadHistory(),
                          child: _OrdersListView(
                            orders: orders,
                            hasMore: hasMore,
                            onLoadMore: () => _loadMore(),
                          ),
                        ),
                  CurierHistoryLoadingMore(:final orders) => RefreshIndicator(
                      onRefresh: () async => _loadHistory(),
                      child: _OrdersListView(
                        orders: orders,
                        hasMore: true,
                        isLoadingMore: true,
                      ),
                    ),
                  _ => context.loadingIndicator,
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Логика (оставляем в родителе для управления состоянием) ---
  void _showPicker({required bool isStart}) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: isStart ? DateTime(2020) : (_startDate ?? DateTime(2020)),
      maxTime: DateTime.now(),
      onConfirm: (date) {
        setState(() {
          if (isStart) {
            _startDate = date;
            if (_endDate != null && _endDate!.isBefore(_startDate!)) _endDate = null;
          } else {
            _endDate = date;
          }
        });
        _loadHistory();
      },
      currentTime: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      locale: LocaleType.ru,
    );
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _loadHistory();
  }

  void _loadHistory() {
    final fmt = DateFormat('yyyy-MM-dd');
    context.read<CurierCubit>().getCurierHistory(
          startDate: _startDate != null ? fmt.format(_startDate!) : null,
          endDate: _endDate != null ? fmt.format(_endDate!) : null,
        );
  }

  void _loadMore() {
    final fmt = DateFormat('yyyy-MM-dd');
    context.read<CurierCubit>().getCurierHistory(
          startDate: _startDate != null ? fmt.format(_startDate!) : null,
          endDate: _endDate != null ? fmt.format(_endDate!) : null,
          loadMore: true,
        );
  }
}

class _OrdersListView extends StatefulWidget {
  final List<CurierEntity> orders;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const _OrdersListView({
    required this.orders,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  State<_OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<_OrdersListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      if (widget.hasMore && !widget.isLoadingMore && widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.orders.length + (widget.hasMore && widget.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= widget.orders.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return HistoryCardWidget(order: widget.orders[index]);
      },
    );
  }
}
