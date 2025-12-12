import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/cart.svg', width: 200, height: 200),
          const SizedBox(height: 16),
          Text(context.l10n.noOrders,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          Text(context.l10n.addToCart,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  )),
        ],
      ),
    );
  }
}
