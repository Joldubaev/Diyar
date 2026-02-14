import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/curier/curier.dart';
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
  List<OrderActiveItemEntity> orders = [];

  @override
  void initState() {
    context.read<HistoryCubit>().getHistoryOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderHistory)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is GetHistoryOrdersError) {
              return ErrorWithRetry(
                message: context.l10n.errorLoadingOrderHistory,
                onRetry: () => context.read<HistoryCubit>().getHistoryOrders(),
              );
            } else if (state is GetHistoryOrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetHistoryOrdersLoaded) {
              orders = state.orders;
              if (orders.isEmpty) {
                return EmptyActiveOrders(text: context.l10n.noActiveOrders);
              }
            }

            return orders.isEmpty
                ? EmptyActiveOrders(text: context.l10n.noActiveOrders)
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
                              Text(context.l10n.orderDetails,
                                  style: theme.textTheme.bodyLarge!
                                      .copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                              Text('${context.l10n.orderNumber} ${orders[index].orderNumber}',
                                  style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface)),
                              Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), thickness: 1),
                              CustomTile(
                                  title: '${context.l10n.costOfMeal}:',
                                  trailing:
                                      '${(orders[index].price! + (orders[index].deliveryPrice)!).toString()} сом'),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomTextButton(
                                  onPressed: () {
                                    context.pushRoute(
                                      OrderDetailRoute(orderNumber: "${orders[index].orderNumber}"),
                                    );
                                  },
                                  textButton: context.l10n.orderDetailsText,
                                  description: context.l10n.orderCancelText2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
