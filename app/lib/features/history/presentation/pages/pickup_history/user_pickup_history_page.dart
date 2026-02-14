import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/features/history/presentation/widgets/error_widget.dart';
import 'package:diyar/features/history/presentation/widgets/pickup_order_status_badge.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UserPickupHistoryPage extends StatefulWidget {
  const UserPickupHistoryPage({super.key});

  @override
  State<UserPickupHistoryPage> createState() => _UserPickupHistoryPageState();
}

class _UserPickupHistoryPageState extends State<UserPickupHistoryPage> {
  PickupHistoryResponseEntity? response;
  int currentPage = 1;
  final int pageSize = 10;

  @override
  void initState() {
    context.read<HistoryCubit>().getPickupHistory(pageNumber: currentPage, pageSize: pageSize);
    super.initState();
  }

  void _loadPage(int page) {
    setState(() {
      currentPage = page;
    });
    context.read<HistoryCubit>().getPickupHistory(pageNumber: page, pageSize: pageSize);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.pickup)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is GetPickupHistoryError) {
              return ErrorWithRetry(
                message: context.l10n.errorLoadingOrderHistory,
                onRetry: () => _loadPage(currentPage),
              );
            } else if (state is GetPickupHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetPickupHistoryLoaded) {
              response = state.response;
            }

            final orders = response?.orders ?? [];
            final totalPages = response?.totalPages ?? 0;

            return Column(
              children: [
                Expanded(
                  child: orders.isEmpty
                      ? EmptyActiveOrders(text: context.l10n.noOrderHistory)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${context.l10n.orderNumber} ${orders[index].orderNumber}',
                                            style: theme.textTheme.titleSmall!
                                                .copyWith(color: theme.colorScheme.onSurface)),
                                        PickupOrderStatusBadge(status: orders[index].status),
                                      ],
                                    ),
                                    Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), thickness: 1),
                                    CustomTile(title: 'Стоимость заказа:', trailing: '${orders[index].price} сом'),
                                    if (orders[index].amountToReduce != null && orders[index].amountToReduce! > 0) ...[
                                      const SizedBox(height: 4),
                                      CustomTile(
                                        title: 'Бонусы:',
                                        trailing: _formatPrice(orders[index].amountToReduce!),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    CustomTile(
                                      title: 'Итого:',
                                      trailing: _formatPrice(_calculateFinalTotal(orders[index])),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: SubmitButtonWidget(
                                          title: context.l10n.orderDetailsText,
                                          bgColor: theme.colorScheme.primary,
                                          textStyle:
                                              theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                                          onTap: () {
                                            context.pushRoute(
                                              UserPickupDetailRoute(order: orders[index]),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (totalPages > 1)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: currentPage > 1 ? () => _loadPage(currentPage - 1) : null,
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          '$currentPage / $totalPages',
                          style: theme.textTheme.bodyMedium,
                        ),
                        IconButton(
                          onPressed: currentPage < totalPages ? () => _loadPage(currentPage + 1) : null,
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
    );
  }

  String _formatPrice(double price) {
    return price % 1 == 0 ? '${price.toInt()} сом' : '${price.toStringAsFixed(2)} сом';
  }

  double _calculateFinalTotal(UserPickupHistoryEntity order) {
    final price = order.price ?? 0;
    final bonus = order.amountToReduce ?? 0.0;
    return price - bonus;
  }
}
