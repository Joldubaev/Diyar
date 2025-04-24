import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/presentation.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/category_list.dart';

@RoutePage()
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _activeIndex = ValueNotifier<int>(0);
  List<CategoryFoodEntity> menu = [];
  List<CategoryEntity> category = [];

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(GetFoodsByCategoryEvent());
    context.read<CartCubit>().getCartItems();
    _itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    _scrollController.dispose();
    _activeIndex.dispose();
    super.dispose();
  }

  void _onScroll() {
    final indices = _itemPositionsListener.itemPositions.value
        .where((itemPosition) => itemPosition.itemLeadingEdge < 0.5)
        .map((itemPosition) => itemPosition.index)
        .toList();
    if (indices.isNotEmpty && _activeIndex.value != indices.first) {
      _activeIndex.value = indices.first;
    }
  }

  Future<void> _scrollToCategory(int index) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    _activeIndex.value = index;

    context.read<MenuBloc>().add(
          GetProductsEvent(foodName: category[index].name),
        );

    final scrollPosition = index * 100.0;
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is GetFoodsByCategoryLoading) {
            Center(child: CircularProgressIndicator());
          } else if (state is GetFoodsByCategoryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.loadedWrong),
              ),
            );
          }
          if (state is GetFoodsByCategoryLoaded) {
            category = state.categories;
            if (_activeIndex.value == 0 && state.categories.isNotEmpty) {
              context.read<MenuBloc>().add(
                    GetProductsEvent(foodName: state.categories[0].name),
                  );
            }
          } else if (state is GetProductsLoaded) {
            menu = state.foods;
          } else if (state is GetProductsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.loadedWrong),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetFoodsByCategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFoodsByCategoryFailure) {
            return Center(child: Text(context.l10n.loadedWrong));
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuHeaderWidget(
                  onTapMenu: (int index) {
                    context.router.maybePop();
                    _scrollToCategory(index);
                  },
                ),
                const SizedBox(height: 10),
                CategoryList(
                  categories: category,
                  activeIndex: _activeIndex,
                  onCategoryTap: _scrollToCategory,
                  scrollController: _scrollController,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<MenuBloc>().add(GetFoodsByCategoryEvent());
                    },
                    child: ProductsList(
                      menu: menu,
                      activeIndex: _activeIndex,
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
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
