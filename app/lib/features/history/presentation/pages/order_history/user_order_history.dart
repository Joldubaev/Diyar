import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/history/history.dart';
import 'package:diyar/features/history/presentation/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UserOrderHistoryPage extends StatefulWidget {
  const UserOrderHistoryPage({super.key});

  @override
  State<UserOrderHistoryPage> createState() => _UserOrderHistoryPageState();
}

class _UserOrderHistoryPageState extends State<UserOrderHistoryPage> {
  late final HistoryCubit _historyCubit;
  HistoryDateFilterValue _filter = const HistoryDateFilterValue.all();

  @override
  void initState() {
    super.initState();
    _historyCubit = di.sl<HistoryCubit>();
    _historyCubit.getHistoryOrders();
  }

  @override
  void dispose() {
    _historyCubit.close();
    super.dispose();
  }

  void _onFilterChanged(HistoryDateFilterValue filter) {
    setState(() => _filter = filter);
    _historyCubit.setHistoryDateFilter(filter.range);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _historyCubit,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.orderHistory)),
        body: Column(
          children: [
            HistoryDateFilterBar(value: _filter, onChanged: _onFilterChanged),
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  if (state is GetHistoryOrdersError) {
                    return ErrorWithRetry(
                      message: context.l10n.errorLoadingOrderHistory,
                      onRetry: () => _historyCubit.getHistoryOrders(),
                    );
                  }
                  if (state is! GetHistoryOrdersLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orders = state.orders;
                  if (orders.isEmpty) {
                    return HistoryEmptyWidget(
                      text: state.dateRange != null
                          ? 'За выбранный период заказов нет'
                          : context.l10n.noOrderHistory,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => _historyCubit.getHistoryOrders(),
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
                              label: '${context.l10n.costOfMeal}:',
                              value: '${order.price ?? 0} сом',
                            ),
                            HistoryCardRow(
                              label: 'Доставка:',
                              value: '${order.deliveryPrice ?? 0} сом',
                            ),
                            if ((order.amountToReduce ?? 0) > 0)
                              HistoryCardRow(
                                label: 'Бонусы:',
                                value: '-${order.amountToReduce} сом',
                              ),
                            HistoryCardRow(
                              label: 'Итого:',
                              value: '${order.totalPrice} сом',
                            ),
                          ],
                          onDetails: () => context.pushRoute(
                            OrderDetailRoute(orderNumber: '${order.orderNumber}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
