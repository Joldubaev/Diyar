import 'package:flutter/material.dart';

class AddressSelectionSubmitButton extends StatelessWidget {
  final ThemeData theme;
  final String? address;
  final bool isLoading;
  final double deliveryPrice;
  final VoidCallback onConfirm;

  const AddressSelectionSubmitButton({
    super.key,
    required this.theme,
    required this.address,
    required this.isLoading,
    required this.deliveryPrice,
    required this.onConfirm,
  });

  String get _priceText =>
      deliveryPrice % 1 == 0 ? '${deliveryPrice.toInt()} сом' : '${deliveryPrice.toStringAsFixed(2)} сом';

  @override
  Widget build(BuildContext context) {
    final isEnabled = address != null && !isLoading;
    final deliveryText = 'Доставка: $_priceText';

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isEnabled ? onConfirm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              deliveryText,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 26, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
