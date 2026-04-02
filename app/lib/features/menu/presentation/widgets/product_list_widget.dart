import 'package:diyar/common/components/components.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/presentation/cubit/menu_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProductsList extends StatelessWidget {
  final ValueNotifier<int> activeIndex;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const ProductsList({
    super.key,
    required this.activeIndex,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuProductsCubit, MenuProductsState>(
      builder: (context, menuState) {
        if (menuState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (menuState.error != null) {
          return Center(
            child: Text('Ошибка: ${menuState.error}'),
          );
        }
        if (menuState.foods.isEmpty) {
          return const Center(child: Text('Нет продуктов в этой категории'));
        }

        final foods = menuState.foods.first.foodModels;
        if (foods.isEmpty) {
          return const Center(child: Text('Нет продуктов в этой категории'));
        }

        return BlocBuilder<CartBloc, CartState>(
          buildWhen: (prev, curr) =>
              curr is CartLoaded || curr is CartInitial,
          builder: (context, cartState) {
            final quantityMap = <String, int>{};
            if (cartState is CartLoaded) {
              for (final item in cartState.items) {
                final id = item.food?.id;
                if (id != null) quantityMap[id] = item.quantity ?? 0;
              }
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.74,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return ProductItemWidget(
                  key: ValueKey(food.id),
                  food: food,
                  quantity: quantityMap[food.id] ?? 0,
                );
              },
            );
          },
        );
      },
    );
  }
}
