import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class UserPickupDetailPage extends StatefulWidget {
  final UserPickupHistoryModel order;
  const UserPickupDetailPage({super.key, required this.order});

  @override
  State<UserPickupDetailPage> createState() => _UserPickupDetailPageState();
}

class _UserPickupDetailPageState extends State<UserPickupDetailPage> {
  UserPickupHistoryModel get order => widget.order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: SingleChildScrollView(
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
                'Время выдачи',
                order.prepareFor ?? "",
                'history',
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
                order.foods!.map((e) => "${e.name} (${e.quantity})").join('\n'),
                'meal',
              ),
              _buildDetailItem(
                context.l10n.cutlery,
                "${order.dishesCount}",
                'cutler',
              ),
              _buildDetailItem(
                context.l10n.total,
                "${order.price} сом",
                'del',
              ),
            ]),
          ],
        ),
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
