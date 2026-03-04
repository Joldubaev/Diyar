import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.orderHistory,
          style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Grid with 2 columns
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  OrderButton(
                    text: context.l10n.activeOrders,
                    icon: 'assets/images/active_order.png',
                    onPressed: () {
                      context.router.push(const ActiveOrderRoute());
                    },
                  ),
                  OrderButton(
                    text: context.l10n.pickup,
                    icon: 'assets/images/pickup.png',
                    onPressed: () {
                      context.router.push(const UserPickupHistoryRoute());
                    },
                  ),
                  OrderButton(
                    text: context.l10n.orderHistory,
                    icon: 'assets/images/order_history.png',
                    onPressed: () {
                      context.router.push(const UserOrderHistoryRoute());
                    },
                  ),
                  OrderButton(
                    text: "История бонусов",
                    icon: 'assets/images/bonus_history.png',
                    onPressed: () {
                      context.router.push(const BonusTransactionsRoute());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
