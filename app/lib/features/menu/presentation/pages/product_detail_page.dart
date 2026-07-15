import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
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
              // Блок гарниров виден всегда: выбор не должен исчезать после
              // добавления в корзину — смена гарнира создаёт новую конфигурацию.
              if (needsGarnish)
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: ProductDetailGarnishSection(),
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
      create: (context) {
        final cubit = sl<GarnishCubit>();
        final cartState = context.read<CartBloc>().state;
        cubit.load().then((_) {
          // Если конфигурация блюда уже в корзине — предвыбираем её гарнир,
          // чтобы панель сразу показала «Уже в корзине» с её количеством.
          if (cubit.isClosed || cartState is! CartLoaded) return;
          final row = cartState.items
              .where((e) => e.food?.id == food.id && (e.quantity ?? 0) > 0)
              .firstOrNull;
          if (row != null) cubit.preselectGarnishId(row.garnish?.id);
        });
        return cubit;
      },
      child: scaffold,
    );
  }
}
