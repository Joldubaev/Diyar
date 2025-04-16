import '../../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyCurierOrder extends StatelessWidget {
  const EmptyCurierOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/man_empty.svg',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 10),
          Text(context.l10n.noOrders,
              style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
