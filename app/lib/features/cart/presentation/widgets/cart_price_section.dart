import 'package:diyar/features/cart/presentation/cubit/cart_price_cubit.dart';
import 'package:diyar/features/cart/presentation/widgets/total_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Секция с итоговой ценой корзины
/// Оптимизирована через BlocSelector для перерисовки только при изменении цен
class CartPriceSection extends StatelessWidget {
  const CartPriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartPriceCubit, CartPriceState, CartPriceCalculated?>(
      selector: (state) => state is CartPriceCalculated ? state : null,
      builder: (context, priceData) {
        if (priceData == null) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SliverToBoxAdapter(
          child: TotalPriceWidget(
            itemsPrice: priceData.itemsPrice,
            containerPrice: priceData.containerPrice,
            monetaryDiscountAmount: priceData.monetaryDiscount,
            finalTotalPrice: priceData.subtotalPrice,
          ),
        );
      },
    );
  }
}
