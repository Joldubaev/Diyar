import 'package:diyar/common/calculiator/order_calculation_service.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cutlery_cubit.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_price_cubit.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_content_wrapper.dart';

class CartView extends StatelessWidget {
  final List<CartItemEntity> initialItems;

  const CartView({
    super.key,
    required this.initialItems,
  });

  @override
  Widget build(BuildContext context) {
    return CartInitializer(
      child: _CartProviders(
        initialItems: initialItems,
        child: const _CartViewContent(),
      ),
    );
  }
}

/// Провайдеры и слушатели для корзины
class _CartProviders extends StatelessWidget {
  final List<CartItemEntity> initialItems;
  final Widget child;

  const _CartProviders({
    required this.initialItems,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            // Получаем актуальные данные из CartBloc, если доступны
            final cartBloc = context.maybeRead<CartBloc>();
            final items = cartBloc?.state is CartLoaded ? (cartBloc!.state as CartLoaded).items : initialItems;

            return CartPriceCubit(
              OrderCalculationService(),
              initialItems: items,
            );
          },
        ),
        BlocProvider(
          create: (_) => CartCutleryCubit(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeContentCubit, HomeContentState>(
            listener: (context, state) {
              if (state is GetSalesLoaded) {
                context.read<CartPriceCubit>().updateDiscountFromSales(state.sales);
              }
            },
          ),
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartLoaded) {
                context.read<CartPriceCubit>().updateCartItems(state.items);
              }
            },
          ),
        ],
        child: child,
      ),
    );
  }
}

class _CartViewContent extends StatelessWidget {
  const _CartViewContent();

  @override
  Widget build(BuildContext context) {
    return CartContentWrapper(
      onEmpty: () => const CartEmptyWidget(),
      onLoading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Padding(
          padding: EdgeInsets.only(top: 32),
          child: CartItemsSkeleton(),
        ),
      ),
      builder: (items) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomScrollView(
          slivers: [
            CartItemsSection(items: items),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const CartPriceSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            const CartDishesSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            CartTimerSection(cartItems: items),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
