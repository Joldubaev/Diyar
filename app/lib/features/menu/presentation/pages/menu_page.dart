import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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

    final categoryName = categories[index].name;
    if (categoryName != null) {
      context.read<MenuBloc>().add(
            GetProductsEvent(foodName: categoryName),
          );
    } else {
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
        listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
        listener: (context, state) {
          if (state is GetFoodsByCategoryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.loadedWrong),
              ),
            );
          }
          if (state is GetFoodsByCategoryLoaded) {
            categories = state.categories;
            if (_activeIndex.value == 0 &&
                state.categories.isNotEmpty &&
                state.categories[0].name != null) {
              final firstCategoryName = state.categories[0].name!;
              context.read<MenuBloc>().add(
                    GetProductsEvent(foodName: firstCategoryName),
                  );
            }
          } else if (state is GetProductsLoaded) {
            menu = state.foods;
          } else if (state is GetProductsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Ошибка загрузки продуктов: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MenuInitial) {
            if (categories.isNotEmpty &&
                _activeIndex.value < categories.length &&
                categories[_activeIndex.value].name != null) {
              context.read<MenuBloc>().add(
                    GetProductsEvent(foodName: categories[_activeIndex.value].name!),
                  );
            }
          }
        },
        buildWhen: (prev, curr) {
          if (prev.runtimeType != curr.runtimeType) return true;
          if (curr is GetFoodsByCategoryLoaded && prev is GetFoodsByCategoryLoaded) {
            return curr.categories != prev.categories;
          }
          if (curr is GetProductsLoaded && prev is GetProductsLoaded) {
            return curr.foods != prev.foods;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetFoodsByCategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetFoodsByCategoryFailure) {
            return Center(child: Text(context.l10n.loadedWrong));
          }

          final bool isProductsLoading = state is GetProductsLoading;
          final bool hasProductsLoadingFailed = state is GetProductsFailure;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuHeaderWidget(
                  onTapMenu: _scrollToCategory,
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
                      if (details.primaryVelocity == null) return;
                      if (details.primaryVelocity! < 0) {
                        final targetIndex = _activeIndex.value + 1;
                        if (targetIndex < categories.length) {
                          _scrollToCategory(targetIndex);
                        }
                      } else if (details.primaryVelocity! > 0) {
                        final targetIndex = _activeIndex.value - 1;
                        if (targetIndex >= 0) {
                          _scrollToCategory(targetIndex);
                        }
                      }
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<MenuBloc>().add(GetFoodsByCategoryEvent());
                        if (categories.isNotEmpty &&
                            _activeIndex.value < categories.length &&
                            categories[_activeIndex.value].name != null) {
                          context.read<MenuBloc>().add(
                                GetProductsEvent(
                                  foodName: categories[_activeIndex.value].name!,
                                ),
                              );
                        }
                      },
                      child: _buildProductSection(
                        state,
                        isProductsLoading,
                        hasProductsLoadingFailed,
                      ),
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

  /// Анимирует только смену состояний: loading / error / контент.
  /// GridView не пересоздаётся при смене категории (стабильный ключ 'content').
  Widget _buildProductSection(
    MenuState state,
    bool isProductsLoading,
    bool hasProductsLoadingFailed,
  ) {
    final String sectionKey;
    Widget child;
    if (isProductsLoading) {
      sectionKey = 'loading';
      child = const _ShimmerProductsList();
    } else if (hasProductsLoadingFailed && menu.isEmpty) {
      sectionKey = 'error';
      final errorMessage = state is GetProductsFailure ? state.message : 'Неизвестная ошибка';
      child = Center(
        child: Text('Ошибка загрузки продуктов: $errorMessage'),
      );
    } else {
      sectionKey = 'content';
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
        key: ValueKey(sectionKey),
        child: child,
      ),
    );
  }
}

class _ShimmerProductsList extends StatelessWidget {
  const _ShimmerProductsList();

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
