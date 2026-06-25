import 'package:diyar/common/components/components.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/presentation/cubit/menu_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';

const _kMenuEmptyIllustration = 'assets/icons/amico.svg';

/// Сплошная лента меню: одна секция = одна категория (заголовок + грид блюд).
/// Индекс элемента списка 1:1 совпадает с индексом категории, что упрощает
/// синхронизацию с верхним таб-баром.
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

        return BlocBuilder<CartBloc, CartState>(
          buildWhen: (prev, curr) => curr is CartLoaded || curr is CartInitial,
          builder: (context, cartState) {
            final quantityMap = <String, int>{};
            if (cartState is CartLoaded) {
              for (final item in cartState.items) {
                final id = item.food?.id;
                if (id != null) quantityMap[id] = item.quantity ?? 0;
              }
            }

            return ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemCount: sections.length,
              padding: const EdgeInsets.only(bottom: 24),
              itemBuilder: (context, index) => _CategorySectionView(
                section: sections[index],
                quantityMap: quantityMap,
              ),
            );
          },
        );
      },
    );
  }
}

class _CategorySectionView extends StatelessWidget {
  final CategorySection section;
  final Map<String, int> quantityMap;

  const _CategorySectionView({
    required this.section,
    required this.quantityMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Text(
            section.categoryName.trim().isNotEmpty ? section.categoryName : 'Без названия',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _buildBody(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (section.isLoading) {
      return const _SectionShimmer();
    }
    if (section.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.wifi_off_outlined, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(section.error!, style: Theme.of(context).textTheme.bodySmall)),
          ],
        ),
      );
    }
    if (section.foods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          'В этой категории пока нет блюд',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: section.foods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.71,
      ),
      itemBuilder: (context, index) {
        final food = section.foods[index];
        return ProductItemWidget(
          key: ValueKey(food.id),
          food: food,
          quantity: quantityMap[food.id] ?? 0,
        );
      },
    );
  }
}

class _SectionShimmer extends StatelessWidget {
  const _SectionShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
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
