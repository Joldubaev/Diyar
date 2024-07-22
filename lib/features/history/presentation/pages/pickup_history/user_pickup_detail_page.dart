import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class UserPickupDetailPage extends StatefulWidget {
  final UserPickupHistoryModel order;
  const UserPickupDetailPage({super.key, required this.order});

  @override
  State<UserPickupDetailPage> createState() => _UserPickupDetailPageState();
}

class _UserPickupDetailPageState extends State<UserPickupDetailPage> {
  UserPickupHistoryModel get order => widget.order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: Card(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.1))),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.2), height: 1),
          itemCount: _buildDetailList().length,
          itemBuilder: (context, index) {
            final detail = _buildDetailList()[index];
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(detail.title,
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface))),
                    Expanded(
                        child: Text(detail.value,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onSurface))),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<OrderDetailItem> _buildDetailList() {
    final totalPrice = order.price!;
    return [
      OrderDetailItem(
          title: context.l10n.orderNumber, value: order.orderNumber.toString()),
      OrderDetailItem(title: context.l10n.name, value: order.userName ?? ""),
      OrderDetailItem(title: context.l10n.phone, value: order.userPhone ?? ""),
      OrderDetailItem(
          title: context.l10n.timeD, value: order.timeRequest ?? ""),
      OrderDetailItem(
          title: context.l10n.food,
          value:
              order.foods!.map((e) => "${e.name} (${e.quantity})\n").join('')),
      OrderDetailItem(
          title: context.l10n.cutlery, value: "${order.dishesCount}"),
      OrderDetailItem(title: context.l10n.paymentMethod, value: 'Наличные'),
      OrderDetailItem(
          title: context.l10n.totalOrderAmount, value: "${order.price} сом"),
      OrderDetailItem(
          title: context.l10n.totalWithDelivery, value: "$totalPrice сом"),
      OrderDetailItem(title: context.l10n.comment, value: order.comment ?? ""),
    ];
  }
}

class OrderDetailItem {
  final String title;
  final String value;

  OrderDetailItem({required this.title, required this.value});
}
