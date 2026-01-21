import 'package:diyar/core/theme/theme_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/common/food_card/utils/food_price_formatter.dart';
import '../widgets/order_icon_widget.dart';
import '../widgets/order_title_widget.dart';
import '../widgets/order_subtitle_widget.dart';
import '../widgets/order_info_section_widget.dart';
import '../widgets/order_price_section_widget.dart';
import '../widgets/order_actions_row_widget.dart';

/// Виджет карточки заказа для курьера
class CurierOrderCard extends StatelessWidget {
  final CurierEntity order;
  final VoidCallback onFinish;
  final VoidCallback onOpenMap;
  final VoidCallback onDetails;
  final VoidCallback onCall;

  const CurierOrderCard({
    super.key,
    required this.order,
    required this.onFinish,
    required this.onOpenMap,
    required this.onDetails,
    required this.onCall,
  });

  // Вычисляемые значения вынесены из build с явными типами
  int get _totalPrice => (order.price ?? 0) + (order.deliveryPrice ?? 0);
  String get _formattedAddress => _buildAddress();
  String get _formattedPrice => FoodPriceFormatter.formatPriceWithCurrency(_totalPrice);

  String _buildAddress() {
    final address = '${order.address ?? ''} ${order.houseNumber ?? ''}'.trim();
    return address.isNotEmpty ? address : 'Не указан';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: OrderIconWidget(theme: theme),
        title: OrderTitleWidget(orderNumber: '${order.orderNumber ?? ''}'),
        subtitle: OrderSubtitleWidget(price: _formattedPrice, theme: theme),
        children: [
          const Divider(height: 1),
          _OrderContent(
            order: order,
            totalPrice: _totalPrice,
            formattedPrice: _formattedPrice,
            formattedAddress: _formattedAddress,
            onDetails: onDetails,
            onFinish: onFinish,
            onOpenMap: onOpenMap,
            onCall: onCall,
          ),
        ],
      ),
    );
  }
}

/// Контент карточки заказа
class _OrderContent extends StatelessWidget {
  final CurierEntity order;
  final int totalPrice;
  final String formattedPrice;
  final String formattedAddress;
  final VoidCallback onDetails;
  final VoidCallback onFinish;
  final VoidCallback onOpenMap;
  final VoidCallback onCall;

  const _OrderContent({
    required this.order,
    required this.totalPrice,
    required this.formattedPrice,
    required this.formattedAddress,
    required this.onDetails,
    required this.onFinish,
    required this.onOpenMap,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderInfoSectionWidget(
            order: order,
            formattedAddress: formattedAddress,
          ),
          const SizedBox(height: 12),
          OrderPriceSectionWidget(
            totalPrice: totalPrice,
            formattedPrice: formattedPrice,
            theme: context.theme,
          ),
          const SizedBox(height: 16),
          OrderActionsRowWidget(
            onDetails: onDetails,
            onFinish: onFinish,
            onOpenMap: onOpenMap,
            onCall: onCall,
          ),
        ],
      ),
    );
  }
}
