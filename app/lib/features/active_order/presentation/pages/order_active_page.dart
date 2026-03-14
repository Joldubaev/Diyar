import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ActiveOrderPage extends StatelessWidget {
  const ActiveOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // BlocProvider.value — используем синглтон, не закрываем его при pop.
    // Тот же экземпляр, что и в MainHomePage → баннер реагирует на изменения.
    return BlocProvider.value(
      value: di.sl<ActiveOrderCubit>()..getActiveOrders(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.activeOrders)),
        body: BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
          builder: (context, state) {
            return switch (state) {
              ActiveOrdersLoading() || ActiveOrderInitial() => const Center(child: CircularProgressIndicator()),
              ActiveOrdersError(message: final msg) => EmptyActiveOrders(text: msg),
              ActiveOrdersLoaded(orders: final orders) => orders.isEmpty
                  ? EmptyActiveOrders(text: context.l10n.noActiveOrders)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _OrderCard(order: order, theme: theme);
                      },
                    ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderActiveItemEntity order;
  final ThemeData theme;

  const _OrderCard({required this.order, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${context.l10n.orderNumber} ${order.orderNumber}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  order.paymentDisplayState == PaymentDisplayState.paid ? Icons.check_circle : Icons.access_time,
                  size: 16,
                  color: order.paymentDisplayState.color,
                ),
                const SizedBox(width: 4),
                Text(
                  order.paymentDisplayState.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: order.paymentDisplayState.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OrderStepper(
              orderStatus: OrderStatusEntity(
                orderNumber: order.orderNumber,
                status: order.status,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CancelOrderButton(order: order),
        ),
        const SizedBox(width: 8),
        CustomTextButton(
          onPressed: () => context.pushRoute(
            OrderDetailRoute(orderNumber: "${order.orderNumber}"),
          ),
          textButton: context.l10n.orderDetails,
        ),
      ],
    );
  }
}
