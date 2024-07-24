import 'package:auto_route/auto_route.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class OrderDetailPage extends StatefulWidget {
  final String orderNumber;
  const OrderDetailPage({Key? key, required this.orderNumber})
      : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late OrderActiveItemModel order;

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().getOrderItem(widget.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is GetOrderItemError) {
            SnackBarMessage().showErrorSnackBar(
              message: context.l10n.errorLoadingData,
              context: context,
            );
          }
        },
        builder: (context, state) {
          if (state is GetOrderItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetOrderItemError) {
            return Center(child: Text(context.l10n.errorLoadingData));
          } else if (state is GetOrderItemLoaded) {
            order = state.order;
          }

          final totalPrice = (order.price ?? 0) + (order.deliveryPrice ?? 0);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _buildCard([
                  _buildDetailItem(
                    context.l10n.name,
                    order.userName ?? "",
                    'about',
                  ),
                  _buildDetailItem(
                    context.l10n.yourAddress,
                    order.address ?? "",
                    'location',
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildDetailItem2(
                        context.l10n.entranceNumber,
                        order.entrance ?? "",
                      ),
                      _buildDetailItem2(
                        context.l10n.houseNumber,
                        order.houseNumber ?? "",
                      ),
                      _buildDetailItem2(
                        context.l10n.floor,
                        order.floor ?? "",
                      ),
                      _buildDetailItem2(
                        context.l10n.entrance,
                        order.entrance ?? "",
                      ),
                      _buildDetailItem2(
                        context.l10n.timeD,
                        order.timeRequest ?? "",
                      ),
                    ],
                  ),
                  _buildDetailItem(
                    context.l10n.phone,
                    order.userPhone ?? "",
                    'phone',
                  ),
                  _buildDetailItem(
                    context.l10n.comment,
                    order.comment ?? "",
                    'document',
                  ),
                ]),
                _buildCard([
                  _buildDetailItem(
                    'Ваш заказ',
                    order.foods!
                        .map((e) => "${e.name} (${e.quantity})")
                        .join('\n'),
                    'meal',
                  ),
                  _buildDetailItem(
                    context.l10n.cutlery,
                    "${order.dishesCount}",
                    'cutler',
                  ),
                  _buildDetailItem(
                    context.l10n.total,
                    "$totalPrice ${context.l10n.som}",
                    'del',
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailItem2(String title, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          const SizedBox(width: 50),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, String icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/icons/$icon.svg'),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  thickness: 1,
                ),
                Text(
                  title,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
