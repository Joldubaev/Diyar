import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/components/product/custom_gridview.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/data/models/food_model.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/search_bar.dart' show MenuSearchBar;

@RoutePage()
class SearchMenuPage extends StatefulWidget {
  const SearchMenuPage({super.key});

  @override
  State<SearchMenuPage> createState() => _SearchMenuPageState();
}

class _SearchMenuPageState extends State<SearchMenuPage> {
  List<FoodEntity> foods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.searchMeal,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Column(
        children: [
          MenuSearchBar(
            onSearch: (value) {
              EasyDebounce.debounce(
                'menu-search-debounce',
                const Duration(milliseconds: 500),
                () => context.read<MenuBloc>().add(SearchFoodsEvent(query: value)),
              );
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocConsumer<MenuBloc, MenuState>(
              listener: (context, state) {
                if (state is SearchFoodsLoaded) {
                  setState(() => foods = state.foods);
                  context.read<CartCubit>().getCartItems();
                }
              },
              builder: (context, state) {
                if (state is SearchFoodsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchFoodsFailure) {
                  return Center(child: Text(context.l10n.notFound));
                }

                if (foods.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.searchByNames,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return StreamBuilder<List<CartItemModel>>(
                  stream: context
                      .read<CartCubit>()
                      .cart
                      .map((entities) => entities.map((entity) => CartItemModel.fromEntity(entity)).toList()),
                  builder: (context, snapshot) {
                    List<CartItemModel> cart = snapshot.data ?? [];

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
                          orElse: () => CartItemModel(
                            food: FoodModel.fromEntity(food),
                            quantity: 0,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
