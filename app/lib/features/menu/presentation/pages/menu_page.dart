import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/common.dart';
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

  // Кубиты держим как поля State, чтобы колбэк позиций (вне дерева виджетов)
  // мог обращаться к ним напрямую, а не через context.read.
  late final MenuCategoryCubit _categoryCubit;
  late final MenuProductsCubit _productsCubit;

  /// Защита от петли: при тапе по табу мы программно скроллим ленту,
  /// и нужно игнорировать колбэки позиций, иначе подсветка «дёргается».
  bool _isProgrammaticScroll = false;

  // Лента теперь плоская (заголовки + ряды блюд), поэтому индекс элемента
  // списка не равен индексу категории — маппинг даёт MenuFlatList.
  // Кэшируем его по identity списка секций, т.к. колбэк позиций
  // вызывается на каждый кадр скролла.
  List<CategorySection>? _flatSource;
  MenuFlatList? _flatCache;

  MenuFlatList get _flatList {
    final sections = _productsCubit.state.sections;
    if (_flatCache == null || !identical(sections, _flatSource)) {
      _flatSource = sections;
      _flatCache = MenuFlatList.fromSections(sections);
    }
    return _flatCache!;
  }

  @override
  void initState() {
    super.initState();
    _categoryCubit = di.sl<MenuCategoryCubit>()..loadCategories();
    _productsCubit = di.sl<MenuProductsCubit>();
    _itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    _categoryScrollController.dispose();
    _categoryCubit.close();
    _productsCubit.close();
    super.dispose();
  }

  /// Скролл ленты → подсветка активной категории в таб-баре.
  void _onPositionsChanged() {
    if (_isProgrammaticScroll || !mounted) return;
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final visible = positions.where((p) => p.itemTrailingEdge > 0).toList()
      ..sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));
    if (visible.isEmpty) return;

    // Элемент, занимающий верх вьюпорта: последний, чей верхний край ушёл выше 0.
    final top = visible.lastWhere(
      (p) => p.itemLeadingEdge <= 0,
      orElse: () => visible.first,
    );

    final categoryIndex = _flatList.categoryOf(top.index);
    if (_categoryCubit.state.activeIndex != categoryIndex) {
      _categoryCubit.selectCategory(categoryIndex);
      _animateCategoryBarTo(categoryIndex);
    }
  }

  /// Тап по табу → программный скролл ленты к секции категории.
  void _onCategoryTap(int index) {
    _categoryCubit.selectCategory(index);
    _animateCategoryBarTo(index);

    if (!_itemScrollController.isAttached) return;
    final firstIndexes = _flatList.firstIndexOfCategory;
    if (index >= firstIndexes.length) return;
    _isProgrammaticScroll = true;
    _itemScrollController.scrollTo(
      index: firstIndexes[index],
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 420), () {
      if (mounted) _isProgrammaticScroll = false;
    });
  }

  void _animateCategoryBarTo(int index) {
    if (!_categoryScrollController.hasClients) return;
    final target = (index * 100.0).clamp(
      0.0,
      _categoryScrollController.position.maxScrollExtent,
    );
    _categoryScrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _refresh() async {
    _productsCubit.clearCache();
    await _categoryCubit.loadCategories();
    await _productsCubit.loadAllSections(_categoryCubit.state.categories);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _categoryCubit),
        BlocProvider.value(value: _productsCubit),
      ],
      child: Scaffold(
        body: BlocListener<MenuCategoryCubit, MenuCategoryState>(
          listenWhen: (prev, curr) => prev.categories.isEmpty && curr.categories.isNotEmpty,
          listener: (context, state) {
            _productsCubit.loadAllSections(state.categories);
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 6),
                _buildCategoryList(),
                const SizedBox(height: 6),
                _buildProductArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocSelector<MenuCategoryCubit, MenuCategoryState, List<CategoryEntity>>(
      selector: (state) => state.categories,
      builder: (context, categories) => MenuHeaderWidget(
        onTapMenu: _onCategoryTap,
        categoriesFromPage: categories,
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<MenuCategoryCubit, MenuCategoryState>(
      builder: (context, state) {
        if (state.categories.isEmpty) return const SizedBox.shrink();
        return CategoryList(
          categories: state.categories,
          activeIndex: ValueNotifier(state.activeIndex),
          onCategoryTap: _onCategoryTap,
          scrollController: _categoryScrollController,
        );
      },
    );
  }

  Widget _buildProductArea() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<MenuProductsCubit, MenuProductsState>(
          builder: (context, state) {
            if (state.sections.isEmpty) {
              if (state.error != null) {
                return AppEmptyWidget(
                  icon: Icons.wifi_off_outlined,
                  title: 'Не удалось загрузить',
                  subtitle: state.error,
                );
              }
              return const _ShimmerGrid();
            }
            return ProductsList(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
            );
          },
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
        mainAxisExtent: 200,
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
