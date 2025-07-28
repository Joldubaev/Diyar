import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/presentation/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularFoodSectionWidget extends StatelessWidget {
  final List<FoodEntity> menu;

  const PopularFoodSectionWidget({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          List<CartItemEntity> cartItems = [];
          if (cartState is CartLoaded) {
            cartItems = cartState.items;
          }

          final carouselItems = menu.map((food) {
            final cartItem = cartItems.firstWhere(
              (element) => element.food?.id == food.id,
              orElse: () => CartItemEntity(food: food, quantity: 0),
            );

            return ProductItemWidget(
              food: food,
              quantity: cartItem.quantity ?? 0,
              width: 140,
              height: 180,
              isCompact: true,
            );
          }).toList();

          return CarouselWidget(
            height: 180,
            viewportFraction: 0.85,
            autoScrollDuration: const Duration(seconds: 3),
            animationDuration: const Duration(milliseconds: 500),
            autoScroll: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: carouselItems,
          );
        },
      ),
    );
  }
}
