
import 'package:diyar/core/core.dart';
import 'package:diyar/features/history/presentation/presentation.dart';
import 'package:diyar/features/order_detail/order_detail.dart';
import 'package:flutter/material.dart';

class AddressGridWidget extends StatelessWidget {
  final OrderDetailEntity order;
  const AddressGridWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailItem2(
          title: context.l10n.entranceNumber,
          value: order.entrance ?? "",
        ),
        DetailItem2(
          title: context.l10n.houseNumber,
          value: order.houseNumber ?? "",
        ),
        DetailItem2(
          title: context.l10n.floor,
          value: order.floor ?? "",
        ),
        DetailItem2(
          title: context.l10n.ofice,
          value: order.kvOffice ?? "",
        ),
        DetailItem2(
          title: context.l10n.timeD,
          value: order.timeRequest ?? "",
        ),
      ],
    );
  }
}
