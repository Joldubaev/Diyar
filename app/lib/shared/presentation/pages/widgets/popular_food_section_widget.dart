
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularFoodSectionWidget extends StatelessWidget {
  final List<FoodEntity> menu;

  const PopularFoodSectionWidget({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.popularFood,
          style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 220,
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              List<CartItemEntity> cartItems = [];
              if (cartState is CartLoaded) {
                cartItems = cartState.items;
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  final food = menu[index];
                  final cartItem = cartItems.firstWhere(
                    (element) => element.food?.id == food.id,
                    orElse: () => CartItemEntity(food: food, quantity: 0),
                  );
                  return SizedBox(
                    width: 200,
                    child: ProductItemWidget(
                      food: food,
                      quantity: cartItem.quantity ?? 0,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
