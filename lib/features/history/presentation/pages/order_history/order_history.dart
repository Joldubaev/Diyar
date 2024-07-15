import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderActiveItemModel> orders = [];

  @override
  void initState() {
    context.read<HistoryCubit>().getHistoryOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is GetHistoryOrdersError) {
            return Center(
                child: Text(context.l10n.errorLoadingOrderHistory,
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.error)));
          } else if (state is GetHistoryOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetHistoryOrdersLoaded) {
            orders = state.orders;
            if (orders.isEmpty) {
              return Center(child: Text(context.l10n.noOrderHistory));
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.orderDetails,
                          style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                      Text(
                          '${context.l10n.orderNumber} ${orders[index].orderNumber}',
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: theme.colorScheme.onSurface)),
                      Divider(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          thickness: 1),
                      CustomTile(
                          title: '${context.l10n.costOfMeal}:',
                          trailing: '${orders[index].price} сoм'),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomTextButton(
                          onPressed: () {
                            context.pushRoute(
                              OrderDetailRoute(
                                  orderNumber: "${orders[index].orderNumber}"),
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
    );
  }
}
