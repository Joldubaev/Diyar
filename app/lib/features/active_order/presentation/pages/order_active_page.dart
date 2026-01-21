import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ActiveOrderPage extends StatelessWidget {
  const ActiveOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Запускаем загрузку только при создании страницы
    context.read<ActiveOrderCubit>().getActiveOrders();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.activeOrders)),
      body: BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
        builder: (context, state) {
          // Senior-подход: использование паттерн-матчинга
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
            // Игнорируем состояния деталей заказа для этой страницы
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

// Выносим карточку в отдельный приватный виджет
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
            // Номер заказа
            Text(
              '${context.l10n.orderNumber} ${order.orderNumber}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // Степпер статуса заказа
            OrderStepper(
              orderStatus: OrderStatusEntity(
                orderNumber: order.orderNumber,
                status: order.status,
              ),
            ),
            const SizedBox(height: 16),
            // Кнопки действий
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
