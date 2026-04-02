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
      buildWhen: (prev, curr) => curr is CartLoaded || curr is CartInitial,
      builder: (context, cartState) {
        final quantityMap = <String, int>{};
        if (cartState is CartLoaded) {
          for (final item in cartState.items) {
            final id = item.food?.id;
            if (id != null) quantityMap[id] = item.quantity ?? 0;
          }
        }

        return PaginatedMasonryGridView<FoodEntity>(
          items: menu,
          isLoadingMore: false,
          loadMore: () {},
          shrinkWrap: true,
          itemBuilder: (context, food) {
            return ProductItemWidget(
              food: food,
              quantity: quantityMap[food.id] ?? 0,
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
