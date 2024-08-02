import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/features.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            DetailCard(
              children: [
                DetailItem(
                  title: context.l10n.name,
                  value: order.userName ?? "",
                  icon: 'about',
                ),
                DetailItem(
                  title: 'Время выдачи',
                  value: order.prepareFor ?? "",
                  icon: 'history',
                ),
                DetailItem(
                  title: context.l10n.phone,
                  value: order.userPhone ?? "",
                  icon: 'phone',
                ),
                DetailItem(
                  title: context.l10n.comment,
                  value: order.comment ?? "",
                  icon: 'document',
                ),
              ],
            ),
            DetailCard(
              children: [
                DetailItem(
                  title: 'Ваш заказ',
                  value: order.foods!
                      .map((e) => "${e.name} (${e.quantity})")
                      .join('\n'),
                  icon: 'meal',
                ),
                DetailItem(
                  title: context.l10n.cutlery,
                  value: "${order.dishesCount}",
                  icon: 'cutler',
                ),
                DetailItem(
                  title: context.l10n.total,
                  value: "${order.price} сом",
                  icon: 'del',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  final List<Widget> children;
  const DetailCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
