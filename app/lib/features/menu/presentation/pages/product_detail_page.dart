import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget {
  final int? quantity;
  final FoodEntity food;

  const ProductDetailPage({
    super.key,
    required this.food,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          food.name ?? 'Описание блюда',
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'food_image_${food.id}',
                child: ProductImage(food: food),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      food.name ?? 'Название продукта',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          food.weight ?? 'Вес не указан',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                          ),
                        ),
                        Text(
                          '${food.price ?? '0'} сом',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      food.description ?? 'Описание отсутствует.',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 28),
                    CartControls(food: food, quantity: quantity),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartControls extends StatelessWidget {
  final FoodEntity food;
  final int? quantity;

  const CartControls({
    super.key,
    required this.food,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemQuantity = 0;
        CartItemEntity? cartItem;
        if (state is CartLoaded) {
          cartItem = state.items.firstWhere(
            (element) => element.food?.id == food.id,
            orElse: () => CartItemEntity(food: food, quantity: 0),
          );
          itemQuantity = cartItem.quantity ?? 0;
        } else if (state is CartLoading || state is CartInitial) {
          // Optionally show a loading indicator or disable buttons
          // For simplicity, we'll just show 0 and buttons might be disabled based on quantity
        } else if (state is CartError) {
          // Optionally show an error indicator
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CounterButton(
              icon: Icons.remove,
              onPressed: itemQuantity > 0
                  ? () => _handleCartAction(context, cartItem ?? CartItemEntity(food: food, quantity: 0),
                      isIncrement: false)
                  : null,
            ),
            SizedBox(
              width: 60,
              child: Text(
                "$itemQuantity",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            CounterButton(
              icon: Icons.add,
              isIncrement: true,
              onPressed: () =>
                  _handleCartAction(context, cartItem ?? CartItemEntity(food: food, quantity: 0), isIncrement: true),
            ),
          ],
        );
      },
    );
  }

  void _handleCartAction(BuildContext context, CartItemEntity cartItem, {required bool isIncrement}) {
    if (!UserHelper.isAuth()) {
      showDialog(
        context: context,
        builder: (context) => RegistrationAlertDialog(
          onRegister: () {
            Navigator.of(context).pop();
            context.router.push(const SignInRoute());
          },
          onLogin: () => Navigator.of(context).pop(),
        ),
      );
      return;
    }

    final currentQuantity = cartItem.quantity ?? 0;
    final cartBloc = context.read<CartBloc>();
    final foodId = food.id;

    if (foodId == null) return;

    if (isIncrement) {
      if (currentQuantity == 0) {
        cartBloc.add(AddItemToCart(CartItemEntity(food: food, quantity: 1)));
      } else {
        cartBloc.add(IncrementItemQuantity(foodId));
      }
    } else {
      if (currentQuantity > 1) {
        cartBloc.add(DecrementItemQuantity(foodId));
      } else if (currentQuantity == 1) {
        cartBloc.add(RemoveItemFromCart(foodId));
      }
    }
  }
}
