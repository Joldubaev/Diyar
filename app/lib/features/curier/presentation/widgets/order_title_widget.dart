import 'package:diyar/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';

/// Заголовок заказа
class OrderTitleWidget extends StatelessWidget {
  final String orderNumber;

  const OrderTitleWidget({
    super.key,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Заказ №$orderNumber',
      style: context.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
