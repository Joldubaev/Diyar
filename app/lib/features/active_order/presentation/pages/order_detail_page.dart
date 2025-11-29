import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/history.dart';
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
  late OrderActiveItemEntity order;

  @override
  void initState() {
    super.initState();
    context.read<ActiveOrderCubit>().getOrderItem(widget.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: BlocConsumer<ActiveOrderCubit, ActiveOrderState>(
        listener: (context, state) {
          if (state is OrderItemError) {
            SnackBarMessage().showErrorSnackBar(
              message: context.l10n.errorLoadingData,
              context: context,
            );
          }
        },
        builder: (context, state) {
          if (state is OrderItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderItemError) {
            return Center(child: Text(context.l10n.errorLoadingData));
          } else if (state is OrderItemLoaded) {
            order = state.order;
          }

          final totalPrice = (order.price ?? 0) + (order.deliveryPrice ?? 0);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                DetailCardWidget(children: [
                  DetailItem(
                    icon: 'about',
                    title: context.l10n.name,
                    value: order.userName ?? "",
                  ),
                  DetailItem(
                    icon: 'location',
                    title: context.l10n.yourAddress,
                    value: order.address ?? "",
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                  ),
                  DetailItem(
                    icon: 'phone',
                    title: context.l10n.phone,
                    value: order.userPhone ?? "",
                  ),
                  DetailItem(
                    icon: 'document',
                    title: context.l10n.comment,
                    value: order.comment ?? "",
                  ),
                ]),
                DetailCardWidget(children: [
                  DetailItem(
                    icon: 'meal',
                    title: 'Ваш заказ',
                    value: order.foods!.map((e) => "${e.name} (${e.quantity})").join('\n'),
                  ),
                  DetailItem(
                    icon: 'cutler',
                    title: context.l10n.cutlery,
                    value: "${order.dishesCount}",
                  ),
                  DetailItem(
                    icon: 'del',
                    title: context.l10n.change,
                    value: "${order.sdacha} сом",
                  ),
                  DetailItem(
                    icon: 'del',
                    title: 'Оплата',
                    value: order.status == 'UnPaid' ? 'Не Оплачено' : 'Оплачено',
                  ),
                  DetailItem(
                    icon: 'del',
                    title: context.l10n.total,
                    value: "$totalPriceсом",
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
