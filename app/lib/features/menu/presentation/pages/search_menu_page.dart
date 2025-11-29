import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/menu.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SearchMenuPage extends StatelessWidget {
  const SearchMenuPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.searchMeal,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MenuSearchBar(
                onSearch: (value) {
                  if (value.isEmpty) {
                    EasyDebounce.cancel('menu-search-debounce');
                    context.read<MenuBloc>().add(ClearSearchEvent());
                  } else {
                    EasyDebounce.debounce(
                      'menu-search-debounce',
                      const Duration(milliseconds: 500),
                      () => context.read<MenuBloc>().add(SearchFoodsEvent(query: value)),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<MenuBloc, MenuState>(
                  builder: (context, menuState) {
                    List<FoodEntity> currentFoods = [];
                    if (menuState is SearchFoodsLoaded) {
                      currentFoods = menuState.foods;
                      log("SearchFoodsLoaded: ${currentFoods.length}", name: "SEARCH_LOADED");
                    }

                    if (menuState is SearchFoodsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (menuState is SearchFoodsFailure) {
                      final errorMessage = menuState.message.isNotEmpty ? menuState.message : context.l10n.loadedWrong;
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Ошибка поиска: $errorMessage",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    if (menuState is MenuInitial) {
                      return Center(
                        child: Text(
                          context.l10n.searchByNames,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    if (menuState is SearchFoodsLoaded && currentFoods.isEmpty) {
                      return Center(child: Text(context.l10n.notFound));
                    }

                    return BlocBuilder<CartBloc, CartState>(
                      builder: (context, cartState) {
                        List<CartItemEntity> cartItems = [];
                        if (cartState is CartLoaded) {
                          cartItems = cartState.items;
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.80,
                          ),
                          itemCount: currentFoods.length,
                          itemBuilder: (context, index) {
                            final food = currentFoods[index];
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
