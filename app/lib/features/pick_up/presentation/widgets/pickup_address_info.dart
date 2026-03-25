import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class PickupAddressInfo extends StatelessWidget {
  const PickupAddressInfo({
    super.key,
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.orderPickupAd,
          style: context.textTheme.bodyMedium!.copyWith(fontSize: 16),
        ),
        Text(
          l10n.address,
          style: context.textTheme.bodyMedium!.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}
