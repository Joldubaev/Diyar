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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.orderHistory,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.92,
                children: [
                  OrderMenuCard(
                    title: context.l10n.activeOrders,
                    image: 'assets/images/active_order.png',
                    onTap: () {
                      context.router.push(const ActiveOrderRoute());
                    },
                  ),
                  OrderMenuCard(
                    title: context.l10n.pickup,
                    image: 'assets/images/pickup.png',
                    onTap: () {
                      context.router.push(const UserPickupHistoryRoute());
                    },
                  ),
                  OrderMenuCard(
                    title: context.l10n.orderHistory,
                    image: 'assets/images/order_history.png',
                    onTap: () {
                      context.router.push(const UserOrderHistoryRoute());
                    },
                  ),
                  OrderMenuCard(
                    title: "История бонусов",
                    image: 'assets/images/bonus_history.png',
                    onTap: () {
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
