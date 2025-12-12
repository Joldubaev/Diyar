import 'package:diyar/features/cart/presentation/cubit/cart_cutlery_cubit.dart';
import 'package:diyar/features/cart/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Секция выбора столовых приборов
/// Оптимизирована через BlocSelector для перерисовки только при изменении количества
class CartDishesSection extends StatelessWidget {
  const CartDishesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCutleryCubit, CartCutleryState, int>(
      selector: (state) => state is CartCutlerySet ? state.count : 0,
      builder: (context, currentCount) {
        return SliverToBoxAdapter(
          child: DishesWidget(
            initialCount: currentCount,
            onChanged: (newCount) {
              context.read<CartCutleryCubit>().setCutleryCount(newCount);
            },
          ),
        );
      },
    );
  }
}
