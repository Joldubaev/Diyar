import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/curier/presentation/presentation.dart';
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UserPickupHistoryPage extends StatefulWidget {
  const UserPickupHistoryPage({super.key});

  @override
  State<UserPickupHistoryPage> createState() => _UserPickupHistoryPageState();
}

class _UserPickupHistoryPageState extends State<UserPickupHistoryPage> {
  List<UserPickupHistoryModel> orders = [];

  @override
  void initState() {
    context.read<HistoryCubit>().getPickupHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.pickup)),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is GetPickupHistoryError) {
            return Center(
              child: Text(
                context.l10n.errorLoadingOrderHistory,
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is GetPickupHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetPickupHistoryLoaded) {
            orders = state.orders;
          }

          return orders.isEmpty
              ? EmptyActiveOrders(text: context.l10n.noOrderHistory)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${context.l10n.orderNumber} ${orders[index].orderNumber}',
                                style: theme.textTheme.titleSmall!.copyWith(
                                    color: theme.colorScheme.onSurface)),
                            Divider(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                thickness: 1),
                            CustomTile(
                                title: 'Стоимость заказа:',
                                trailing: '${orders[index].price} сoм'),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: SubmitButtonWidget(
                                  title: context.l10n.orderDetailsText,
                                  bgColor: theme.colorScheme.primary,
                                  textStyle: theme.textTheme.bodyLarge!
                                      .copyWith(
                                          color: theme.colorScheme.onPrimary),
                                  onTap: () {
                                    context.pushRoute(
                                      UserPickupDetailRoute(
                                          order: orders[index]),
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
                );
        },
      ),
    );
  }
}
