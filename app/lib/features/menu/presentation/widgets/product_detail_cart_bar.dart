import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Нижняя панель с счётчиком количества и кнопками +/- для добавления в корзину.
class ProductDetailCartBar extends StatelessWidget {
  const ProductDetailCartBar({super.key, required this.food});

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemQuantity = 0;
        CartItemEntity? cartItem;

        if (state is CartLoaded) {
          cartItem = state.items.firstWhere(
            (e) => e.food?.id == food.id,
            orElse: () => CartItemEntity(food: food, quantity: 0),
          );
          itemQuantity = cartItem.quantity ?? 0;
        }

        final effectiveItem = cartItem ?? CartItemEntity(food: food, quantity: 0);

        return _ProductDetailQuantityBar(
          quantity: itemQuantity,
          onDecrement: itemQuantity > 0 ? () => _handleCartAction(context, effectiveItem, isIncrement: false) : null,
          onIncrement: () => _handleCartAction(context, effectiveItem, isIncrement: true),
        );
      },
    );
  }

  void _handleCartAction(
    BuildContext context,
    CartItemEntity cartItem, {
    required bool isIncrement,
  }) {
    if (!UserHelper.isAuth()) {
      showDialog(
        context: context,
        builder: (dialogContext) => RegistrationAlertDialog(
          onRegister: () {
            Navigator.of(dialogContext).pop();
            context.router.push(const SignInRoute());
          },
          onLogin: () => Navigator.of(dialogContext).pop(),
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

class _ProductDetailQuantityBar extends StatelessWidget {
  const _ProductDetailQuantityBar({
    required this.quantity,
    this.onDecrement,
    this.onIncrement,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          _CapsuleActionButton(
            icon: Icons.remove_rounded,
            onPressed: onDecrement,
          ),
          Expanded(
            child: Text(
              '$quantity',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _CapsuleActionButton(
            icon: Icons.add_rounded,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _CapsuleActionButton extends StatelessWidget {
  const _CapsuleActionButton({
    required this.icon,
    this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final bgColor = isEnabled ? context.colorScheme.primary : context.colorScheme.onSurface.withValues(alpha: 0.08);
    final iconColor = isEnabled ? context.colorScheme.onPrimary : context.colorScheme.onSurface.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, size: 24, color: iconColor),
          ),
        ),
      ),
    );
  }
}
