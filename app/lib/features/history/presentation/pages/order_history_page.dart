import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Text(context.l10n.orderHistory, style: theme.textTheme.bodyLarge!.copyWith(color: AppColors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OrderButton(
                text: context.l10n.activeOrders,
                icon: 'assets/icons/del.svg',
                onPressed: () {
                  context.router.push(const ActiveOrderRoute());
                },
              ),
              const SizedBox(height: 20),
              OrderButton(
                text: context.l10n.pickup,
                icon: 'assets/icons/pickup.svg',
                onPressed: () {
                  context.router.push(const UserPickupHistoryRoute());
                },
              ),
              const SizedBox(height: 20),
              OrderButton(
                text: context.l10n.orderHistory,
                icon: 'assets/icons/history.svg',
                onPressed: () {
                  context.router.push(const UserOrderHistoryRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
