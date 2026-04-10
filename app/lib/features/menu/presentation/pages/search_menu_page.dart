import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/common/components/product/product_card_constants.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/presentation/cubit/search_cubit.dart';
import 'package:diyar/features/menu/presentation/widgets/widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SearchMenuPage extends StatelessWidget {
  const SearchMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MenuSearchCubit>(),
      child: Builder(
        builder: (context) => Scaffold(
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
                        context.read<MenuSearchCubit>().clear();
                      } else {
                        EasyDebounce.debounce(
                          'menu-search-debounce',
                          const Duration(milliseconds: 500),
                          () => context
                              .read<MenuSearchCubit>()
                              .search(value),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BlocBuilder<MenuSearchCubit, MenuSearchState>(
                      builder: (context, state) {
                        if (state.isEmpty) {
                          return Center(
                            child: Text(
                              context.l10n.searchByNames,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.error != null) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Ошибка поиска: ${state.error}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        if (state.results.isEmpty) {
                          return Center(
                            child: Text(context.l10n.notFound),
                          );
                        }

                        return BlocBuilder<CartBloc, CartState>(
                          buildWhen: (prev, curr) =>
                              curr is CartLoaded || curr is CartInitial,
                          builder: (context, cartState) {
                            final quantityMap = <String, int>{};
                            if (cartState is CartLoaded) {
                              for (final item in cartState.items) {
                                final id = item.food?.id;
                                if (id != null) {
                                  quantityMap[id] = item.quantity ?? 0;
                                }
                              }
                            }
                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio:
                                    ProductCardConstants.gridTileChildAspectRatio,
                              ),
                              itemCount: state.results.length,
                              itemBuilder: (context, index) {
                                final food = state.results[index];
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
