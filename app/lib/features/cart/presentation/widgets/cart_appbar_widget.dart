import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class CartAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        onPressed: () => context.maybePop(),
      ),
      title: Text(
        context.l10n.cart,
        style: theme.textTheme.titleSmall?.copyWith(color: AppColors.white),
      ),
      // При необходимости можно добавить кнопки действий, например:
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.delivery_dining, color: AppColors.white),
      //     onPressed: () => _onDeliveryPressed(context),
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // void _onDeliveryPressed(BuildContext context) {
  //   final state = context.read<CartBloc>().state;
  //   if (state is CartLoaded && state.items.isNotEmpty) {
  //     context.router.push(
  //       SecondOrderRoute(
  //         totalPrice: state.totalPrice.toInt(),
  //         cart: state.items,
  //         dishCount: state.totalItems,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(context.l10n.cartIsEmpty)),
  //     );
  //   }
  // }
}
