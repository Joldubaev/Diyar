
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;

class CartAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // final bool isCartNotEmpty = state is CartLoaded && state.items.isNotEmpty;
        // final int totalPrice = state is CartLoaded ? state.totalPrice.toInt() : 0;
        // final int totalItems = state is CartLoaded ? state.totalItems : 0;
        // final List<CartItemEntity> items = state is CartLoaded ? state.items : [];

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
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.delivery_dining,
            //     size: 30,
            //     color: AppColors.white,
            //   ),
            //   onPressed: () {
            //     if (isCartNotEmpty) {
            //       context.router.push(
            //         SecondOrderRoute(
            //           totalPrice: totalPrice,
            //           cart: items,
            //           dishCount: totalItems,
            //         ),
            //       );
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text(context.l10n.cartIsEmpty)),
            //       );
            //     }
            //   },
            // ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
