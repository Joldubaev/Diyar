import 'package:diyar/common/components/components.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/presentation/cubit/menu_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const _kMenuEmptyIllustration = 'assets/icons/amico.svg';

class ProductsList extends StatelessWidget {
  final ValueNotifier<int> activeIndex;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final VoidCallback? onEndReached;
  final String? nextCategoryName;

  const ProductsList({
    super.key,
    required this.activeIndex,
    required this.itemScrollController,
    required this.itemPositionsListener,
    this.onEndReached,
    this.nextCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuProductsCubit, MenuProductsState>(
      builder: (context, menuState) {
        if (menuState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (menuState.error != null) {
          return AppEmptyWidget(
            icon: Icons.wifi_off_outlined,
            title: 'Не удалось загрузить',
            subtitle: menuState.error,
          );
        }
        if (menuState.foods.isEmpty) {
          return const AppEmptyWidget(
            svgAsset: _kMenuEmptyIllustration,
            title: 'Пока нет блюд',
            subtitle: 'В этой категории пока ничего нет. Выберите другую категорию или загляните позже.',
          );
        }

        final foods = menuState.foods.first.foodModels;
        if (foods.isEmpty) {
          return const AppEmptyWidget(
            svgAsset: _kMenuEmptyIllustration,
            title: 'Пока нет блюд',
            subtitle: 'В этой категории пока ничего нет. Выберите другую категорию или загляните позже.',
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

            return NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                if (notification.metrics.extentAfter == 0.0) {
                  onEndReached?.call();
                }
                return false;
              },
              child: CustomScrollView(
                key: ValueKey(foods.isNotEmpty ? foods.first.id : null),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final food = foods[index];
                          return ProductItemWidget(
                            key: ValueKey(food.id),
                            food: food,
                            quantity: quantityMap[food.id] ?? 0,
                          );
                        },
                        childCount: foods.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.71,
                      ),
                    ),
                  ),
                  if (nextCategoryName != null)
                    SliverToBoxAdapter(
                      child: _NextCategoryFooter(
                        categoryName: nextCategoryName!,
                        onTap: onEndReached,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _NextCategoryFooter extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onTap;

  const _NextCategoryFooter({
    required this.categoryName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Следующий раздел',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        categoryName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
