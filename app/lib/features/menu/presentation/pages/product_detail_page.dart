import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/cubit/garnish_cubit.dart';
import 'package:diyar/features/menu/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
    required this.food,
  });

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    final needsGarnish = food.requiresGarnish ?? false;

    final scaffold = Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.colorScheme.onSurface),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          food.name ?? 'Описание блюда',
          style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 320,
                child: Hero(
                  tag: 'food_image_${food.id}',
                  child: ProductImage(food: food),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: ProductDetailInfoSection(food: food),
              ),
              if (needsGarnish)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: _GarnishSlot(food: food),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: ProductDetailCartBar(food: food),
        ),
      ),
    );

    if (!needsGarnish) return scaffold;

    return BlocProvider(
      create: (_) => sl<GarnishCubit>()..load(),
      child: scaffold,
    );
  }
}

/// Показывает блок выбора гарнира, пока блюдо ещё не добавлено в корзину.
class _GarnishSlot extends StatelessWidget {
  const _GarnishSlot({required this.food});

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) => curr is CartLoaded || curr is CartInitial,
      builder: (context, state) {
        final inCart = state is CartLoaded &&
            state.items.any((e) => e.food?.id == food.id && (e.quantity ?? 0) > 0);
        if (inCart) return const SizedBox.shrink();
        return const ProductDetailGarnishSection();
      },
    );
  }
}
