import 'package:diyar/common/components/product/custom_gridview.dart';
import 'package:diyar/common/components/product/product_item_widget.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularFoodSectionWidget extends StatelessWidget {
  final List<FoodEntity> menu;

  const PopularFoodSectionWidget({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartItems = cartState is CartLoaded ? cartState.items : <CartItemEntity>[];

        return PaginatedMasonryGridView<FoodEntity>(
          items: menu,
          isLoadingMore: false,
          loadMore: () {},
          shrinkWrap: true,
          itemBuilder: (context, food) {
            final cartItem = cartItems.firstWhere(
              (e) => e.food?.id == food.id,
              orElse: () => CartItemEntity(food: food, quantity: 0),
            );
            return ProductItemWidget(
              food: food,
              quantity: cartItem.quantity ?? 0,
              isCompact: true,
            );
          },
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.only(bottom: 16),
        );
      },
    );
  }
}
