import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cart_count_badge.dart';

/// FAB корзины на главном экране: иконка, бейдж количества, по тапу — диалог регистрации при необходимости или переход в корзину.
class CartFabWidget extends StatelessWidget {
  const CartFabWidget({
    super.key,
    required this.showRegisterDialog,
  });

  final Future<void> Function(BuildContext context) showRegisterDialog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final fabBackground = theme.colorScheme.primary;
    final fabIconColor = theme.colorScheme.onPrimary;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartCount = state is CartLoaded ? state.totalItems : 0;

        return Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: primary.withValues(alpha: isDark ? 0.22 : 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: fabBackground,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async {
                    final router = context.router;
                    if (!UserHelper.isAuth()) {
                      await showRegisterDialog(context);
                      if (UserHelper.isAuth()) {
                        router.push(const CartRoute());
                      }
                    } else {
                      router.push(const CartRoute());
                    }
                  },
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/cart_icon.svg',
                        height: 33,
                        colorFilter: ColorFilter.mode(
                          fabIconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: CartCountBadge(cartCount: cartCount),
              ),
          ],
        );
      },
    );
  }
}
