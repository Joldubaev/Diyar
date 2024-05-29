import 'package:auto_route/auto_route.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/product/product_item_widget.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/menu/data/models/category_model.dart';
import 'package:diyar/features/menu/menu.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _activeIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<CategoryModel> menu = [];

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getProductsWithMenu();
    context.read<CartCubit>().getCartItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is GetMenuLoaded) {
            menu = state.categories;
          }
        },
        builder: (context, state) {
          if (state is GetMenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetMenuFailure) {
            return Center(child: Text(context.l10n.loadedWrong));
          }
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuHeaderWidget(
                  onTapMenu: (int idx) {
                    _scrollToCategory(idx);
                    context.maybePop();
                  },
                ),
                SizedBox(
                  height: 35,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemCount: menu.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => _scrollToCategory(index),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        decoration: BoxDecoration(
                          color: index == _activeIndex ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Center(
                          child: Text(
                            "${menu[index].category?.name}",
                            style: TextStyle(
                              color: index == _activeIndex ? AppColors.white : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification) {
                        double position = scrollNotification.metrics.pixels;
                        double totalHeight = 0.0;
                        for (int i = 0; i < menu.length; i++) {
                          totalHeight += _calculateCategoryHeight(i);
                          if (position < totalHeight) {
                            setState(() => _activeIndex = i);
                            break;
                          }
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: menu.length,
                      itemBuilder: (context, index) {
                        final category = menu[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                category.category?.name ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: index == _activeIndex ? AppColors.primary : AppColors.black1,
                                ),
                              ),
                            ),
                            StreamBuilder<List<CartItemModel>>(
                                stream: context.read<CartCubit>().cart,
                                builder: (context, snapshot) {
                                  List cart = [];
                                  if (snapshot.hasData) {
                                    cart = snapshot.data ?? [];
                                  }
                                  return GridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    childAspectRatio: 0.72,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: List.generate(
                                      category.foods?.length ?? 0,
                                      (index) {
                                        final food = category.foods![index];
                                        final cartItem = cart.firstWhere(
                                          (element) => element.food?.id == food.id,
                                          orElse: () => CartItemModel(food: food, quantity: 0),
                                        );
                                        return ProductItemWidget(
                                          food: food,
                                          quantity: cartItem.quantity ?? 0,
                                        );
                                      },
                                    ),
                                  );
                                }),
                            const SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _scrollToCategory(int index) {
    double position = 0.0;
    for (int i = 0; i < index; i++) {
      position += _calculateCategoryHeight(i);
    }
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  double _calculateCategoryHeight(int index) {
    double categoryHeight = 40.0;
    double productsHeight = (menu[index].foods?.length ?? 0) * 120.0;
    return categoryHeight + productsHeight;
  }
}
