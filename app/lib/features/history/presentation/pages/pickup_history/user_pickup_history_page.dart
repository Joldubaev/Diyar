import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/history/domain/domain.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/features/history/presentation/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UserPickupHistoryPage extends StatefulWidget {
  const UserPickupHistoryPage({super.key});

  @override
  State<UserPickupHistoryPage> createState() => _UserPickupHistoryPageState();
}

class _UserPickupHistoryPageState extends State<UserPickupHistoryPage> {
  late final HistoryCubit _historyCubit;
  HistoryDateFilterValue _filter = const HistoryDateFilterValue.all();
  PickupHistoryResponseEntity? _response;
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _historyCubit = di.sl<HistoryCubit>();
    _historyCubit.getPickupHistory(pageNumber: _currentPage, pageSize: _pageSize);
  }

  @override
  void dispose() {
    _historyCubit.close();
    super.dispose();
  }

  void _loadPage(int page) {
    setState(() => _currentPage = page);
    _historyCubit.getPickupHistory(pageNumber: page, pageSize: _pageSize);
  }

  void _onFilterChanged(HistoryDateFilterValue filter) {
    setState(() {
      _filter = filter;
      _currentPage = 1;
      _response = null;
    });
    _historyCubit.setPickupDateFilter(filter.range);
  }

  Future<void> _refresh() {
    if (_filter.range != null) {
      return _historyCubit.setPickupDateFilter(_filter.range);
    }
    return _historyCubit.getPickupHistory(pageNumber: _currentPage, pageSize: _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _historyCubit,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.pickup)),
        body: Column(
          children: [
            HistoryDateFilterBar(value: _filter, onChanged: _onFilterChanged),
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  if (state is GetPickupHistoryError) {
                    return ErrorWithRetry(
                      message: context.l10n.errorLoadingOrderHistory,
                      onRetry: _refresh,
                    );
                  }
                  if (state is GetPickupHistoryLoaded) {
                    _response = state.response;
                  } else if (_response == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orders = _response?.orders ?? [];
                  final totalPages = _response?.totalPages ?? 0;

                  if (orders.isEmpty) {
                    return HistoryEmptyWidget(
                      text: _filter.range != null
                          ? 'За выбранный период заказов нет'
                          : context.l10n.noOrderHistory,
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return HistoryOrderCard(
                                orderNumber: order.orderNumber,
                                status: order.status,
                                timeRequest: order.timeRequest,
                                detailsLabel: context.l10n.orderDetailsText,
                                rows: [
                                  HistoryCardRow(
                                    label: 'Стоимость заказа:',
                                    value: '${order.price ?? 0} сом',
                                  ),
                                  if ((order.amountToReduce ?? 0) > 0)
                                    HistoryCardRow(
                                      label: 'Бонусы:',
                                      value: '-${_formatPrice(order.amountToReduce!)}',
                                    ),
                                  HistoryCardRow(
                                    label: 'Итого:',
                                    value: _formatPrice(_finalTotal(order)),
                                  ),
                                ],
                                onDetails: () => context.pushRoute(
                                  UserPickupDetailRoute(order: order),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_filter.range == null && totalPages > 1)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed:
                                    _currentPage > 1 ? () => _loadPage(_currentPage - 1) : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Text('$_currentPage / $totalPages', style: theme.textTheme.bodyMedium),
                              IconButton(
                                onPressed: _currentPage < totalPages
                                    ? () => _loadPage(_currentPage + 1)
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price % 1 == 0 ? '${price.toInt()} сом' : '${price.toStringAsFixed(2)} сом';
  }

  double _finalTotal(UserPickupHistoryEntity order) {
    return (order.price ?? 0) - (order.amountToReduce ?? 0.0);
  }
}
