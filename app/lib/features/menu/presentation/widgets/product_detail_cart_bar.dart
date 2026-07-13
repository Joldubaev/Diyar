import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/cubit/garnish_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Нижняя панель с счётчиком количества и кнопками +/- для добавления в корзину.
class ProductDetailCartBar extends StatelessWidget {
  const ProductDetailCartBar({super.key, required this.food});

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) => curr is CartLoaded || curr is CartInitial,
      builder: (context, state) {
        // Суммарное количество блюда по всем его позициям
        // (у блюда с гарниром может быть несколько позиций — по гарниру).
        var itemQuantity = 0;
        var rows = const <CartItemEntity>[];

        if (state is CartLoaded) {
          rows = state.items.where((e) => e.food?.id == food.id).toList();
          itemQuantity = rows.fold(0, (sum, e) => sum + (e.quantity ?? 0));
        }

        return _ProductDetailQuantityBar(
          quantity: itemQuantity,
          onDecrement: itemQuantity > 0 ? () => _handleCartAction(context, rows, isIncrement: false) : null,
          onIncrement: () => _handleCartAction(context, rows, isIncrement: true),
        );
      },
    );
  }

  void _handleCartAction(
    BuildContext context,
    List<CartItemEntity> rows, {
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

    final cartBloc = context.read<CartBloc>();
    if (food.id == null) return;

    // Гарнир, выбранный в инлайн-блоке (null — «Без гарнира» или не требуется).
    FoodEntity? selectedGarnish;
    if (food.requiresGarnish ?? false) {
      final garnishCubit = context.read<GarnishCubit>();
      final garnishState = garnishCubit.state;
      final selectedIndex = garnishState.selectedIndex;
      // Если гарниров нет (ошибка/пустой список) — не блокируем заказ, кладём блюдо как есть.
      if (isIncrement && garnishState.items.isNotEmpty && selectedIndex == null) {
        // Есть из чего выбрать, но не выбрано — подсвечиваем блок, в корзину не кладём.
        garnishCubit.requestHighlight();
        return;
      }
      if (selectedIndex != null && selectedIndex > 0 && selectedIndex <= garnishState.items.length) {
        selectedGarnish = garnishState.items[selectedIndex - 1];
      }
    }

    if (isIncrement) {
      // Позиция «блюдо + выбранный гарнир»: повторное добавление с тем же
      // гарниром сольётся в одну позицию, с другим — создаст новую.
      cartBloc.add(AddItemToCart(CartItemEntity(
        food: food,
        garnish: selectedGarnish,
        quantity: 1,
      )));
      return;
    }

    // Уменьшаем позицию с текущим выбранным гарниром; если такой нет —
    // первую позицию этого блюда.
    if (rows.isEmpty) return;
    final selectedKey = CartItemEntity(food: food, garnish: selectedGarnish).rowKey;
    final target = rows.firstWhere(
      (e) => e.rowKey == selectedKey,
      orElse: () => rows.first,
    );
    final targetKey = target.rowKey;
    if (targetKey == null) return;
    if ((target.quantity ?? 0) > 1) {
      cartBloc.add(DecrementItemQuantity(targetKey));
    } else {
      cartBloc.add(RemoveItemFromCart(targetKey));
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
