import 'package:flutter/material.dart';
import 'package:diyar/features/curier/curier.dart';
import 'icon_info_row_widget.dart';

/// Секция с информацией о заказе
class OrderInfoSectionWidget extends StatelessWidget {
  final CurierEntity order;
  final String formattedAddress;

  const OrderInfoSectionWidget({
    super.key,
    required this.order,
    required this.formattedAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasUserName) ...[
          IconInfoRowWidget(
            icon: Icons.person_outline,
            label: 'Клиент',
            value: order.userName!,
          ),
          const SizedBox(height: 12),
        ],
        IconInfoRowWidget(
          icon: Icons.location_on_outlined,
          label: 'Адрес',
          value: formattedAddress,
        ),
        if (_hasPhone) ...[
          const SizedBox(height: 12),
          IconInfoRowWidget(
            icon: Icons.phone_outlined,
            label: 'Телефон',
            value: order.userPhone!,
          ),
        ],
      ],
    );
  }

  bool get _hasUserName => order.userName != null && order.userName!.isNotEmpty;
  bool get _hasPhone => order.userPhone != null && order.userPhone!.isNotEmpty;
}
