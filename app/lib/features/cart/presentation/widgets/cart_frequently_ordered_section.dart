import 'package:diyar/common/components/product/product_item_widget.dart';
import 'package:diyar/common/components/text/row_text_widget.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/cart/presentation/cubit/frequently_ordered_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Блок «Так же заказывают» под корзиной — горизонтальная карусель блюд.
/// Пустой список / ошибка / загрузка без данных → блок скрыт.
class CartFrequentlyOrderedSection extends StatelessWidget {
  const CartFrequentlyOrderedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocProvider(
        create: (_) => sl<FrequentlyOrderedCubit>()..load(),
        child: const _FrequentlyOrderedView(),
      ),
    );
  }
}

class _FrequentlyOrderedView extends StatelessWidget {
  const _FrequentlyOrderedView();

  static const double _cardWidth = 150;
  static const double _carouselHeight = 232;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FrequentlyOrderedCubit, FrequentlyOrderedState>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();

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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowTextWidget(text: context.l10n.alsoOrdered, theme: Theme.of(context)),
                const SizedBox(height: 12),
                SizedBox(
                  height: _carouselHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 4),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final food = state.items[index];
                      return SizedBox(
                        width: _cardWidth,
                        child: ProductItemWidget(
                          food: food,
                          quantity: quantityMap[food.id] ?? 0,
                          isCompact: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
