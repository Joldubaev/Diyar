import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/presentation.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:developer';
import 'package:shimmer/shimmer.dart';

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
  List<CategoryEntity> categories = [];

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(GetFoodsByCategoryEvent());
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

    // Проверяем, что имя категории не null
    final categoryName = categories[index].name;
    if (categoryName != null) {
      context.read<MenuBloc>().add(
            GetProductsEvent(foodName: categoryName),
          );
    } else {
      // Обработка случая, когда имя категории null
      log("Error: Category name at index $index is null.");
      // Можно показать сообщение пользователю
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Не удалось загрузить продукты: категория без имени."),
          backgroundColor: Colors.red,
        ),
      );
    }

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
          log("MenuPage Listener State: ${state.runtimeType}");
          if (state is GetFoodsByCategoryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.loadedWrong),
              ),
            );
          }
          if (state is GetFoodsByCategoryLoaded) {
            categories = state.categories;
            if (_activeIndex.value == 0 && state.categories.isNotEmpty && state.categories[0].name != null) {
              final firstCategoryName = state.categories[0].name!;
              context.read<MenuBloc>().add(
                    GetProductsEvent(foodName: firstCategoryName),
                  );
            }
          } else if (state is GetProductsLoaded) {
            menu = state.foods;
            log("MenuPage Listener: ${state.foods.length}", name: "MENU_LOADED");
          } else if (state is GetProductsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Ошибка загрузки продуктов: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          log("MenuPage Builder State: ${state.runtimeType}");
          if (state is GetFoodsByCategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFoodsByCategoryFailure) {
            return Center(child: Text(context.l10n.loadedWrong));
          }
          final bool isProductsLoading = state is GetProductsLoading;
          final bool hasProductsLoadingFailed = state is GetProductsFailure;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuHeaderWidget(
                  onTapMenu: (int index) {
                    _scrollToCategory(index);
                  },
                  categoriesFromPage: categories,
                ),
                const SizedBox(height: 10),
                if (categories.isNotEmpty)
                  CategoryList(
                    categories: categories,
                    activeIndex: _activeIndex,
                    onCategoryTap: _scrollToCategory,
                    scrollController: _scrollController,
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity == null) {
                        return; // Если скорость не определена, ничего не делаем
                      }
                      // Свайп влево  — следующая категория
                      if (details.primaryVelocity! < 0) {
                        // Свайп пальцем справа налево
                        final targetIndex = _activeIndex.value + 1; // Определяем индекс следующей категории
                        if (targetIndex < categories.length) {
                          // Проверяем, что не вышли за пределы списка
                          _scrollToCategory(targetIndex);
                        }
                      }
                      // Свайп вправо— предыдущая категория
                      else if (details.primaryVelocity! > 0) {
                        // Свайп пальцем слева направо
                        final targetIndex = _activeIndex.value - 1; // Определяем индекс предыдущей категории
                        if (targetIndex >= 0) {
                          // Проверяем, что не вышли за пределы списка (в начало)
                          _scrollToCategory(targetIndex);
                        }
                      }
                    },
                    // ... остальной код вашего виджета
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<MenuBloc>().add(GetFoodsByCategoryEvent());
                        if (categories.isNotEmpty &&
                            _activeIndex.value < categories.length &&
                            categories[_activeIndex.value].name != null) {
                          context
                              .read<MenuBloc>()
                              .add(GetProductsEvent(foodName: categories[_activeIndex.value].name!));
                        }
                      },
                      child: _buildProductSection(state, isProductsLoading, hasProductsLoadingFailed),
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

  /// Строит секцию продуктов в зависимости от текущего состояния Bloc
  Widget _buildProductSection(MenuState state, bool isProductsLoading, bool hasProductsLoadingFailed) {
    Widget child;
    if (isProductsLoading) {
      child = _ShimmerProductsList();
    } else if (hasProductsLoadingFailed && menu.isEmpty) {
      String errorMessage = "Неизвестная ошибка";
      if (state is GetProductsFailure) {
        errorMessage = state.message;
      }
      child = Center(child: Text("Ошибка загрузки продуктов: $errorMessage"));
    } else {
      child = ProductsList(
        activeIndex: _activeIndex,
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(_activeIndex.value.toString() + isProductsLoading.toString()),
        child: child,
      ),
    );
  }
}

class _ShimmerProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
