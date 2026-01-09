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
    // Вызываем загрузку конкретного заказа через Cubit
    // Примечание: Если в Cubit нет метода getOrderItem, его нужно добавить в UseCase
    // Либо просто искать заказ в текущем списке ActiveOrdersLoaded

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
        builder: (context, state) {
          // Ищем нужный заказ в загруженном списке, если Cubit хранит список
          if (state is ActiveOrdersLoaded) {
            final order = state.orders.firstWhereOrNull((o) => o.orderNumber.toString() == orderNumber);

            if (order == null) return const Center(child: Text('Заказ не найден'));

            return _OrderDetailContent(order: order);
          }

          if (state is ActiveOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: Text('Ошибка загрузки данных'));
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
    final totalPrice = (order.price ?? 0) + (order.deliveryPrice ?? 0) - (order.amountToReduce ?? 0);

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
            DetailItem(icon: 'reduce', title: 'Скидка', value: "${order.amountToReduce ?? 0} сом"),
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
