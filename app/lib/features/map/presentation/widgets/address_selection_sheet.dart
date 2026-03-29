import 'package:flutter/material.dart';
import 'package:diyar/common/components/components.dart';
import 'address_selection_address_display.dart';
import 'address_selection_submit_button.dart';

class AddressSelectionSheet extends StatelessWidget {
  final ThemeData theme;
  final String? address;
  final bool isLoading;
  final double deliveryPrice;
  final VoidCallback onSearchPressed;
  final VoidCallback onConfirm;

  const AddressSelectionSheet({
    super.key,
    required this.theme,
    required this.address,
    required this.isLoading,
    required this.deliveryPrice,
    required this.onSearchPressed,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomInputWidget(
                  filledColor: theme.colorScheme.surface,
                  hintText: 'Поиск адреса',
                  leading: const Icon(Icons.search),
                  onTap: onSearchPressed,
                  isReadOnly: true,
                ),
              ),
              const SizedBox(height: 12),
              AddressSelectionAddressDisplay(
                theme: theme,
                address: address,
                isLoading: isLoading,
              ),
              const SizedBox(height: 12),
              AddressSelectionSubmitButton(
                theme: theme,
                address: address,
                isLoading: isLoading,
                deliveryPrice: deliveryPrice,
                onConfirm: onConfirm,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
