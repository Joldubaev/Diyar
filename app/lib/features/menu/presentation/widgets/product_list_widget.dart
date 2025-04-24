import 'package:diyar/core/core.dart';
import 'package:diyar/core/components/product/custom_gridview.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProductsList extends StatelessWidget {
  final List<CategoryFoodEntity> menu;
  final ValueNotifier<int> activeIndex;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const ProductsList({
    super.key,
    required this.menu,
    required this.activeIndex,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartItemEntity>>(
      stream: context.read<CartCubit>().cart,
      builder: (context, snapshot) {
        if (menu.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final foods = menu.first.foodModels;
        final cart = snapshot.data ?? [];
        return PaginatedMasonryGridView<FoodEntity>(
          items: foods,
          isLoadingMore: false,
          loadMore: () {}, // Пока оставим пустым, так как у нас нет пагинации
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, food) {
            final cartItem = cart.firstWhere(
              (element) => element.food?.id == food.id,
              orElse: () => CartItemEntity(
                food: food,
                quantity: food.quantity,
              ),
            );
            return ProductItemWidget(
              food: food,
              quantity: cartItem.quantity ?? 0,
            );
          },
        );
      },
    );
  }
}
