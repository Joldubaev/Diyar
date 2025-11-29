import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

@RoutePage()
class UserPickupDetailPage extends StatefulWidget {
  final UserPickupHistoryEntity order;
  const UserPickupDetailPage({super.key, required this.order});

  @override
  State<UserPickupDetailPage> createState() => _UserPickupDetailPageState();
}

class _UserPickupDetailPageState extends State<UserPickupDetailPage> {
  UserPickupHistoryEntity get order => widget.order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            DetailCardWidget(
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
            DetailCardWidget(
              children: [
                DetailItem(
                  title: 'Ваш заказ',
                  value: order.foods!.map((e) => "${e.name} (${e.quantity})").join('\n'),
                  icon: 'meal',
                ),
                DetailItem(
                  title: context.l10n.cutlery,
                  value: "${order.dishesCount}",
                  icon: 'cutler',
                ),
                DetailItem(
                  icon: 'del',
                  title: 'Оплата',
                  value: order.paymentMethod == 'cash' ? 'Наличные' : 'Онлайн оплата',
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
