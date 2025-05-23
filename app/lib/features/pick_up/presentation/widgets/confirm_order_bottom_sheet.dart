import 'package:flutter/material.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/presentation/widgets/info_dialog_widget.dart';
import 'package:diyar/l10n/l10n.dart';

class ConfirmOrderBottomSheet extends StatelessWidget {
  final int totalPrice;
  final VoidCallback onConfirmTap;

  const ConfirmOrderBottomSheet({
    super.key,
    required this.totalPrice,
    required this.onConfirmTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${l10n.orderPickupAd} ${l10n.address}',
                    style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          InfoDialogWidget(title: l10n.orderAmount, description: '$totalPrice сом'),
          const SizedBox(height: 20),
          SubmitButtonWidget(
            textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
            title: l10n.confirmOrder,
            bgColor: AppColors.green,
            onTap: onConfirmTap,
          ),
        ],
      ),
    );
  }
}
