import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class PickupConfirmButton extends StatelessWidget {
  const PickupConfirmButton({
    super.key,
    required this.onConfirmTap,
  });

  final VoidCallback onConfirmTap;

  @override
  Widget build(BuildContext context) {
    return SubmitButtonWidget(
      title: context.l10n.confirmOrder,
      bgColor: context.colorScheme.primary,
      textStyle: context.textTheme.bodyMedium!.copyWith(
        color: context.colorScheme.surface,
      ),
      onTap: onConfirmTap,
    );
  }
}
