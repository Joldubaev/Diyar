import 'package:auto_route/auto_route.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/product/product_item_widget.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/data/models/category_model.dart';
import 'package:diyar/features/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

@RoutePage()
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  int _activeIndex = 0;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollController _scrollController = ScrollController();
  List<CategoryModel> menu = [];

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getProductsWithMenu();
    context.read<CartCubit>().getCartItems();
    _itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final indices = _itemPositionsListener.itemPositions.value
        .where((itemPosition) => itemPosition.itemLeadingEdge < 0.5)
        .map((itemPosition) => itemPosition.index)
        .toList();
    if (indices.isNotEmpty && _activeIndex != indices.first) {
      setState(() {
        _activeIndex = indices.first;
      });
    }
  }

  Future<void> _scrollToCategory(int index) async {
    await _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _activeIndex = index;
    });

    final scrollPosition = index * 100.0;
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is GetMenuLoaded) {
            setState(() => menu = state.categories);
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
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemCount: menu.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => _scrollToCategory(index),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        decoration: BoxDecoration(
                          color: index == _activeIndex
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: index != _activeIndex
                              ? Border.all(
                                  color: theme.colorScheme.onSurface,
                                  width: 0.4)
                              : Border.all(
                                  color: theme.colorScheme.primary, width: 0.4),
                        ),
                        child: Center(
                          child: Text(
                            "${menu[index].category?.name}",
                            style: TextStyle(
                              color: index == _activeIndex
                                  ? theme.colorScheme.surface
                                  : theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<MenuCubit>().getProductsWithMenu();
                    },
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      itemCount: menu.length,
                      itemBuilder: (context, index) {
                        final category = menu[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                category.category?.name ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: index == _activeIndex
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  childAspectRatio: 0.72,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                    category.foods?.length ?? 0,
                                    (index) {
                                      final food = category.foods![index];
                                      final cartItem = cart.firstWhere(
                                        (element) =>
                                            element.food?.id == food.id,
                                        orElse: () => CartItemModel(
                                            food: food, quantity: 0),
                                      );
                                      return ProductItemWidget(
                                        food: food,
                                        quantity: cartItem.quantity ?? 0,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
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
}
