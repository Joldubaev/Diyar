import 'package:diyar/common/components/components.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/cubit/menu_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';

const _kMenuEmptyIllustration = 'assets/icons/amico.svg';
const _kGridSpacing = 14.0;
const _kCardAspectRatio = 0.71;
const _kShimmerRowHeight = 200.0;

/// Плоское представление ленты меню: элемент списка — заголовок категории,
/// ряд из двух блюд или статус секции (шиммер/ошибка/пусто).
/// Ряды вместо целых секций позволяют ScrollablePositionedList строить
/// карточки лениво, а не всю категорию разом (как было с shrinkWrap-гридом).
sealed class MenuListItem {
  /// Индекс категории, которой принадлежит элемент, — для синхронизации
  /// ленты с таб-баром категорий.
  final int categoryIndex;
  const MenuListItem(this.categoryIndex);
}

class _HeaderItem extends MenuListItem {
  final String title;
  const _HeaderItem(super.categoryIndex, this.title);
}

class _FoodRowItem extends MenuListItem {
  /// 1–2 блюда в ряду.
  final List<FoodEntity> foods;
  const _FoodRowItem(super.categoryIndex, this.foods);
}

enum _SectionStatus { loading, error, empty }

class _StatusItem extends MenuListItem {
  final _SectionStatus status;
  final String? message;
  const _StatusItem(super.categoryIndex, this.status, [this.message]);
}

class MenuFlatList {
  final List<MenuListItem> items;

  /// Индекс элемента-заголовка каждой категории — цель прокрутки при тапе по табу.
  final List<int> firstIndexOfCategory;

  const MenuFlatList._(this.items, this.firstIndexOfCategory);

  factory MenuFlatList.fromSections(List<CategorySection> sections) {
    final items = <MenuListItem>[];
    final firstIndex = <int>[];
    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      firstIndex.add(items.length);
      items.add(_HeaderItem(
        i,
        section.categoryName.trim().isNotEmpty ? section.categoryName : 'Без названия',
      ));
      if (section.isLoading) {
        items.add(_StatusItem(i, _SectionStatus.loading));
      } else if (section.error != null) {
        items.add(_StatusItem(i, _SectionStatus.error, section.error));
      } else if (section.foods.isEmpty) {
        items.add(_StatusItem(i, _SectionStatus.empty));
      } else {
        for (var f = 0; f < section.foods.length; f += 2) {
          items.add(_FoodRowItem(
            i,
            section.foods.sublist(f, (f + 2).clamp(0, section.foods.length)),
          ));
        }
      }
    }
    return MenuFlatList._(items, firstIndex);
  }

  /// Категория, которой принадлежит элемент списка.
  int categoryOf(int itemIndex) {
    if (items.isEmpty) return 0;
    return items[itemIndex.clamp(0, items.length - 1)].categoryIndex;
  }
}

/// Сплошная лента меню: заголовки категорий и ряды блюд единым ленивым списком.
class ProductsList extends StatelessWidget {
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const ProductsList({
    super.key,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuProductsCubit, MenuProductsState>(
      builder: (context, menuState) {
        final sections = menuState.sections;
        if (sections.isEmpty) {
          return const AppEmptyWidget(
            svgAsset: _kMenuEmptyIllustration,
            title: 'Пока нет блюд',
            subtitle: 'Меню пустое. Загляните позже.',
          );
        }

        final flat = MenuFlatList.fromSections(sections);

        return BlocBuilder<CartBloc, CartState>(
          buildWhen: (prev, curr) => curr is CartLoaded || curr is CartInitial,
          builder: (context, cartState) {
            final quantityMap = <String, int>{};
            if (cartState is CartLoaded) {
              for (final item in cartState.items) {
                final id = item.food?.id;
                if (id != null) quantityMap[id] = (quantityMap[id] ?? 0) + (item.quantity ?? 0);
              }
            }

            return ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemCount: flat.items.length,
              padding: const EdgeInsets.only(bottom: 24),
              itemBuilder: (context, index) => switch (flat.items[index]) {
                final _HeaderItem item => _CategoryHeader(title: item.title),
                final _StatusItem item => _SectionStatusView(item: item),
                final _FoodRowItem item => _FoodRow(
                    foods: item.foods,
                    quantityMap: quantityMap,
                  ),
              },
            );
          },
        );
      },
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String title;

  const _CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  final List<FoodEntity> foods;
  final Map<String, int> quantityMap;

  const _FoodRow({
    required this.foods,
    required this.quantityMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, _kGridSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) const SizedBox(width: _kGridSpacing),
            Expanded(
              child: i < foods.length
                  ? AspectRatio(
                      aspectRatio: _kCardAspectRatio,
                      child: ProductItemWidget(
                        key: ValueKey(foods[i].id),
                        food: foods[i],
                        quantity: quantityMap[foods[i].id] ?? 0,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionStatusView extends StatelessWidget {
  final _StatusItem item;

  const _SectionStatusView({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (item.status) {
      case _SectionStatus.loading:
        return const _SectionShimmer();
      case _SectionStatus.error:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.wifi_off_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(item.message ?? '', style: theme.textTheme.bodySmall)),
            ],
          ),
        );
      case _SectionStatus.empty:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'В этой категории пока нет блюд',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
    }
  }
}

class _SectionShimmer extends StatelessWidget {
  const _SectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, _kGridSpacing),
      child: SizedBox(
        height: _kShimmerRowHeight,
        child: Row(
          children: [
            for (var i = 0; i < 2; i++) ...[
              if (i > 0) const SizedBox(width: _kGridSpacing),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
