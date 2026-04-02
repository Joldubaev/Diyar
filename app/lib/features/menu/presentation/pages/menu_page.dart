import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
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

class _MenuPageState extends State<MenuPage> {
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();
  final _categoryScrollController = ScrollController();

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _onCategoryTap(BuildContext ctx, int index) {
    final catCubit = ctx.read<MenuCategoryCubit>();
    catCubit.selectCategory(index);

    final name = catCubit.activeCategoryName;
    if (name != null) {
      ctx.read<MenuProductsCubit>().loadProducts(name);
    }

    _categoryScrollController.animateTo(
      index * 100.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<MenuCategoryCubit>()..loadCategories(),
        ),
        BlocProvider(create: (_) => di.sl<MenuProductsCubit>()),
      ],
      child: Builder(
        builder: (ctx) => Scaffold(
          body: BlocListener<MenuCategoryCubit, MenuCategoryState>(
            listenWhen: (prev, curr) =>
                prev.categories.isEmpty && curr.categories.isNotEmpty,
            listener: (context, state) {
              final name = state.categories.firstOrNull?.name;
              if (name != null) {
                context.read<MenuProductsCubit>().loadProducts(name);
              }
            },
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(ctx),
                  const SizedBox(height: 10),
                  _buildCategoryList(ctx),
                  const SizedBox(height: 10),
                  _buildProductArea(ctx),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext ctx) {
    return BlocSelector<MenuCategoryCubit, MenuCategoryState,
        List<CategoryEntity>>(
      selector: (state) => state.categories,
      builder: (context, categories) => MenuHeaderWidget(
        onTapMenu: (i) => _onCategoryTap(ctx, i),
        categoriesFromPage: categories,
      ),
    );
  }

  Widget _buildCategoryList(BuildContext ctx) {
    return BlocBuilder<MenuCategoryCubit, MenuCategoryState>(
      builder: (context, state) {
        if (state.categories.isEmpty) return const SizedBox.shrink();
        return CategoryList(
          categories: state.categories,
          activeIndex: ValueNotifier(state.activeIndex),
          onCategoryTap: (i) => _onCategoryTap(ctx, i),
          scrollController: _categoryScrollController,
        );
      },
    );
  }

  Widget _buildProductArea(BuildContext ctx) {
    return Expanded(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          final catState = ctx.read<MenuCategoryCubit>().state;
          if (details.primaryVelocity! < 0) {
            final next = catState.activeIndex + 1;
            if (next < catState.categories.length) {
              _onCategoryTap(ctx, next);
            }
          } else if (details.primaryVelocity! > 0) {
            final prev = catState.activeIndex - 1;
            if (prev >= 0) _onCategoryTap(ctx, prev);
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            final catCubit = ctx.read<MenuCategoryCubit>();
            final productsCubit = ctx.read<MenuProductsCubit>();
            productsCubit.clearCache();
            await catCubit.loadCategories();
            final name = catCubit.activeCategoryName;
            if (name != null) productsCubit.loadProducts(name);
          },
          child: BlocBuilder<MenuProductsCubit, MenuProductsState>(
            builder: (context, state) {
              if (state.isLoading && state.foods.isEmpty) {
                return const _ShimmerGrid();
              }
              if (state.error != null && state.foods.isEmpty) {
                return Center(child: Text('Ошибка: ${state.error}'));
              }
              return ProductsList(
                activeIndex: ValueNotifier(0),
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid();

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
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
