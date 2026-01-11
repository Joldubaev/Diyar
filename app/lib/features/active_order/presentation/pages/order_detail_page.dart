import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrderDetailPage extends StatelessWidget {
  final String orderNumber;
  const OrderDetailPage({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
        builder: (context, activeState) {
          // Ищем в активных заказах
          if (activeState is ActiveOrdersLoaded) {
            final order = activeState.orders.firstWhereOrNull((o) => o.orderNumber.toString() == orderNumber);
            if (order != null) {
              return _OrderDetailContent(order: order);
            }
          }

          // Если не нашли в активных, ищем в истории
          return BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, historyState) {
              // Загружаем историю, если она еще не загружена
              if (historyState is HistoryInitial || historyState is GetHistoryOrdersError) {
                context.read<HistoryCubit>().getHistoryOrders();
                return const Center(child: CircularProgressIndicator());
              }

              if (historyState is GetHistoryOrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (historyState is GetHistoryOrdersLoaded) {
                final order = historyState.orders.firstWhereOrNull((o) => o.orderNumber.toString() == orderNumber);
                if (order != null) {
                  return _OrderDetailContent(order: order);
                }
              }

              // Проверяем состояние активных заказов
              if (activeState is ActiveOrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Если заказ не найден ни в активных, ни в истории
              return const Center(child: Text('Заказ не найден'));
            },
          );
        },
      ),
    );
  }
}

// Весь UI контент вынесен отдельно для scannability
class _OrderDetailContent extends StatelessWidget {
  final OrderActiveItemEntity order;
  const _OrderDetailContent({required this.order});

  @override
  Widget build(BuildContext context) {
    // Бонусы не вычитаются из итоговой суммы, отправляем полную стоимость
    final totalPrice = (order.price ?? 0) + (order.deliveryPrice ?? 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          DetailCardWidget(children: [
            DetailItem(icon: 'about', title: context.l10n.name, value: order.userName ?? ""),
            DetailItem(icon: 'location', title: context.l10n.yourAddress, value: order.fullAddress),
            _AddressGrid(order: order),
            DetailItem(icon: 'phone', title: context.l10n.phone, value: order.userPhone ?? ""),
          ]),
          DetailCardWidget(children: [
            DetailItem(
              icon: 'meal',
              title: 'Ваш заказ',
              value: order.foods?.map((e) => "${e.name} (${e.quantity})").join('\n') ?? "",
            ),
            DetailItem(icon: 'cutler', title: context.l10n.cutlery, value: "${order.dishesCount}"),
            if (order.amountToReduce != null && order.amountToReduce! > 0)
              DetailItem(icon: 'check', title: 'Бонусы', value: "${order.amountToReduce!.toStringAsFixed(0)} сом"),
            DetailItem(icon: 'del', title: 'Итого', value: "$totalPrice сом"),
          ]),
          const SizedBox(height: 16),
          CancelOrderButton(order: order),
        ],
      ),
    );
  }
}

class _AddressGrid extends StatelessWidget {
  final OrderActiveItemEntity order;
  const _AddressGrid({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailItem2(
          title: context.l10n.entranceNumber,
          value: order.entrance ?? "",
        ),
        DetailItem2(
          title: context.l10n.houseNumber,
          value: order.houseNumber ?? "",
        ),
        DetailItem2(
          title: context.l10n.floor,
          value: order.floor ?? "",
        ),
        DetailItem2(
          title: context.l10n.ofice,
          value: order.kvOffice ?? "",
        ),
        DetailItem2(
          title: context.l10n.timeD,
          value: order.timeRequest ?? "",
        ),
      ],
    );
  }
}
