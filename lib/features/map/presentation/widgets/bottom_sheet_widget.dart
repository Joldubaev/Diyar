
import 'package:diyar/features/map/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  final ThemeData theme;
  final String? address;
  final double deliveryPrice;
  final VoidCallback onAddressCardTap;

  const BottomSheetWidget({
    Key? key,
    required this.theme,
    required this.address,
    required this.deliveryPrice,
    required this.onAddressCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      constraints: const BoxConstraints(maxHeight: 300, minHeight: 300),
      onClosing: () {},
      builder: (context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        children: [
          DeliveryPriceInfo(
            deliveryPrice: deliveryPrice,
            theme: theme,
          ),
          const SizedBox(height: 10),
          AddressCard(
            theme: theme,
            address: address,
            onTap: onAddressCardTap,
          ),
        ],
      ),
    );
  }
}

