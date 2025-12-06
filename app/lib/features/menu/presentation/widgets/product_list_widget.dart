import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/presentation/bloc/menu_bloc.dart'; // Import MenuBloc and States
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // Keep for parameters, though unused

class ProductsList extends StatefulWidget {
  // Removed menu parameter as we get it from MenuBloc state
  final ValueNotifier<int> activeIndex;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const ProductsList({
    super.key,
    // required this.menu, // Removed
    required this.activeIndex,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    // Combine BlocBuilders: First for Menu, then for Cart inside
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, menuState) {
        if (menuState is GetProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (menuState is GetProductsFailure) {
          return Center(child: Text('Ошибка загрузки продуктов: ${menuState.message}'));
        }
        if (menuState is GetProductsLoaded) {
          if (menuState.foods.isEmpty) {
            return const Center(child: Text('Нет продуктов в этой категории'));
          }

          final categoryFood = menuState.foods.first;
          final foods = categoryFood.foodModels;

          if (foods.isEmpty) {
            return const Center(child: Text('Нет продуктов в этой категории'));
          }

          // Now use BlocBuilder for Cart state
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              List<CartItemEntity> cartItems = [];
              if (cartState is CartLoaded) {
                cartItems = cartState.items;
              }
              // Build grid regardless of cart state, using quantity 0 if not loaded/found
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.80,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  // Find quantity from current cart state
                  final cartItem = cartItems.firstWhere(
                    (element) => element.food?.id == food.id,
                    orElse: () => CartItemEntity(food: food, quantity: 0),
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

        // Если состояние не GetProductsLoaded, показываем пустой экран
        return const Center(child: Text('Нет продуктов в этой категории'));
      },
    );
  }
}
