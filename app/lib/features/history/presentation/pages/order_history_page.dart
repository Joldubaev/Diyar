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
              OrderButton(
                text: context.l10n.activeOrders,
                icon: 'assets/icons/del.svg',
                onPressed: () {
                  context.router.push(const ActiveOrderRoute());
                },
              ),
              const SizedBox(height: 16),
              OrderButton(
                text: context.l10n.pickup,
                icon: 'assets/icons/pickup.svg',
                onPressed: () {
                  context.router.push(const UserPickupHistoryRoute());
                },
              ),
              const SizedBox(height: 16),
              OrderButton(
                text: context.l10n.orderHistory,
                icon: 'assets/icons/history.svg',
                onPressed: () {
                  context.router.push(const UserOrderHistoryRoute());
                },
              ),
              const SizedBox(height: 16),
              OrderButton(
                text: "История бонусов",
                icon: 'assets/icons/bonus.svg',
                onPressed: () {
                  context.router.push(const BonusTransactionsRoute());
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
