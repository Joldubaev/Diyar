import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<CurierOrderModel> orders = [];

  @override
  void initState() {
    context.read<CurierCubit>().getCurierHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.orderHistory,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: BlocConsumer<CurierCubit, CurierState>(
        listener: (context, state) {
          if (state is GetCurierHistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.errorLoadingData),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetCurierHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCurierHistoryError) {
            return Center(child: Text(context.l10n.errorLoadingData));
          } else if (state is GetCurierHistoryLoaded) {
            orders = state.curiers;
            if (state.curiers.isEmpty) {
              return Center(child: Text(context.l10n.noOrders));
            }
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: AppColors.black1.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                      '${context.l10n.orderNumber} ${order.orderNumber ?? ""}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: theme.colorScheme.onSurface)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.l10n.name}: ${order.userName ?? ""}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${context.l10n.addressD}${order.address ?? ""}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${context.l10n.totalAmount}${(order.price ?? 0) + (order.deliveryPrice ?? 0)}',
                        style: Theme.of(context).textTheme.bodyMedium,
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
