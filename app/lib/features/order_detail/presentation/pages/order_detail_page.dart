import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/order_detail/order_detail.dart';
import 'package:diyar/features/order_detail/presentation/widget/adress_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrderDetailPage extends StatefulWidget {
  final String orderNumber;
  const OrderDetailPage({super.key, required this.orderNumber});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _hasTriedApi = false;

  @override
  void initState() {
    super.initState();
    // Загружаем детали заказа через API
    final orderNumber = int.tryParse(widget.orderNumber);
    if (orderNumber != null) {
      _hasTriedApi = true;
      context.read<OrderDetailCubit>().getOrderDetail(orderNumber: orderNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderDetailLoaded) {
            return _OrderDetailContent(order: state.orderDetail);
          }

          if (state is OrderDetailError) {
            // Если API не вернул заказ, ищем в локальных источниках как fallback
            return _buildFallbackSearch();
          }

          // Если еще не загружали через API, показываем загрузку
          if (!_hasTriedApi) {
            return const Center(child: CircularProgressIndicator());
          }

          // Fallback на локальный поиск
          return _buildFallbackSearch();
        },
      ),
    );
  }

  Widget _buildFallbackSearch() {
    return BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
      builder: (context, activeState) {
        // Ищем в активных заказах
        if (activeState is ActiveOrdersLoaded) {
          final order = activeState.orders.firstWhereOrNull(
            (o) => o.orderNumber.toString() == widget.orderNumber,
          );
          if (order != null) {
            final orderDetail = OrderDetailMapper.fromActiveOrder(order);
            return _OrderDetailContent(order: orderDetail);
          }
        }

        // Если не нашли в активных, проверяем заказы курьера
        return BlocBuilder<CurierCubit, CurierState>(
          builder: (context, curierState) {
            if (curierState is CurierMainState) {
              // Ищем в активных заказах курьера
              final curierOrder = curierState.activeOrders.firstWhereOrNull(
                (o) => o.orderNumber?.toString() == widget.orderNumber,
              );
              if (curierOrder != null) {
                final orderDetail = OrderDetailMapper.fromCurierOrder(curierOrder);
                return _OrderDetailContent(order: orderDetail);
              }

              // Если не нашли в активных, проверяем историю курьера
              final historyOrder = curierState.historyOrders.firstWhereOrNull(
                (o) => o.orderNumber?.toString() == widget.orderNumber,
              );
              if (historyOrder != null) {
                final orderDetail = OrderDetailMapper.fromCurierOrder(historyOrder);
                return _OrderDetailContent(order: orderDetail);
              }
            }

            // Если не нашли в заказах курьера, ищем в истории
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
                  final order = historyState.orders.firstWhereOrNull(
                    (o) => o.orderNumber.toString() == widget.orderNumber,
                  );
                  if (order != null) {
                    final orderDetail = OrderDetailMapper.fromActiveOrder(order);
                    return _OrderDetailContent(order: orderDetail);
                  }
                }

                // Если заказ не найден нигде
                return const Center(child: Text('Заказ не найден'));
              },
            );
          },
        );
      },
    );
  }
}

// Весь UI контент вынесен отдельно для scannability
class _OrderDetailContent extends StatelessWidget {
  final OrderDetailEntity order;
  const _OrderDetailContent({required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          DetailCardWidget(children: [
            DetailItem(icon: 'about', title: context.l10n.name, value: order.userName ?? ""),
            DetailItem(icon: 'location', title: context.l10n.yourAddress, value: order.fullAddress),
            AddressGridWidget(order: order),
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
              DetailItem(
                icon: 'check',
                title: 'Бонусы',
                value: order.amountToReduce! % 1 == 0
                    ? "${order.amountToReduce!.toInt()} сом"
                    : "${order.amountToReduce!.toStringAsFixed(2)} сом",
              ),
            DetailItem(
              icon: 'del',
              title: 'Итого',
              value: order.totalPrice % 1 == 0
                  ? "${order.totalPrice.toInt()} сом"
                  : "${order.totalPrice.toStringAsFixed(2)} сом",
            ),
          ]),
          const SizedBox(height: 16),
          if (order.orderNumber != null)
            _CancelOrderButton(
              orderNumber: order.orderNumber!,
              status: order.status,
              address: order.address,
            ),
        ],
      ),
    );
  }
}

/// Кнопка отмены заказа для деталей заказа
class _CancelOrderButton extends StatelessWidget {
  final int orderNumber;
  final String? status;
  final String? address; // Для определения isPickup

  const _CancelOrderButton({
    required this.orderNumber,
    this.status,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    // Проверка условий: кнопка только при статусах Awaits или UnPaid
    final canCancel = status == 'Awaits' || status == 'UnPaid';

    if (!canCancel) return const SizedBox.shrink();

    return OutlinedButton(
      onPressed: () => _showConfirmDialog(context),
      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
      child: const Text('Отменить'),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    AppAlert.showConfirmDialog(
      context: context,
      title: 'Отмена заказа',
      content: Text('Вы уверены, что хотите отменить заказ №$orderNumber?'),
      confirmPressed: () {
        Navigator.of(context).pop();
        // Используем ActiveOrderCubit для отмены заказа
        // Создаем временную сущность только для отмены
        // isPickup определяется автоматически геттером в OrderActiveItemEntity по адресу
        final tempOrder = OrderActiveItemEntity(
          orderNumber: orderNumber,
          status: status,
          address: address,
        );
        context.read<ActiveOrderCubit>().cancelOrder(tempOrder);
      },
      confirmIsDestructive: true,
      confirmText: 'Отменить',
      cancelText: 'Нет',
    );
  }
}
