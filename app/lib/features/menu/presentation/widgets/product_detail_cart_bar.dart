import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/common/food_card/export.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/widgets/garnish/garnish_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Нижняя панель страницы блюда.
///
/// Блюдо с обязательным гарниром: одна кнопка «Добавить» — открывает шит
/// [GarnishPickerSheet], где выбираются гарнир и количество.
///
/// Обычное блюдо: степпер черновика + «Добавить · цена», а если блюдо уже
/// в корзине — пометка «Уже в корзине» и степпер, правящий позицию корзины.
class ProductDetailCartBar extends StatefulWidget {
  const ProductDetailCartBar({super.key, required this.food});

  final FoodEntity food;

  @override
  State<ProductDetailCartBar> createState() => _ProductDetailCartBarState();
}

class _ProductDetailCartBarState extends State<ProductDetailCartBar> {
  /// Черновое количество для блюда, которого ещё нет в корзине.
  int _draftQuantity = 1;

  bool get _needsGarnish => widget.food.requiresGarnish ?? false;

  @override
  Widget build(BuildContext context) {
    if (_needsGarnish) {
      // Весь выбор (гарнир + количество) происходит в шите.
      return _CtaButton(
        label: 'Добавить · ${FoodPriceFormatter.formatPriceWithCurrency(widget.food.price)}',
        emphasized: true,
        onPressed: () => _guarded(context, () => _openGarnishSheet(context)),
      );
    }
    return _buildPlain(context);
  }

  Future<void> _openGarnishSheet(BuildContext context) async {
    final added = await GarnishPickerSheet.show(context, widget.food);
    if (added == true && context.mounted) {
      SnackBarMessage().showSuccessSnackBar(
        message: 'Добавлено в корзину',
        context: context,
      );
    }
  }

  Widget _buildPlain(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) => curr is CartLoaded || curr is CartInitial,
      builder: (context, state) {
        final rowKey = widget.food.id;
        CartItemEntity? cartRow;
        if (state is CartLoaded && rowKey != null) {
          cartRow = state.items.firstWhereOrNull((e) => e.rowKey == rowKey);
        }

        if (cartRow != null) {
          return _InCartBar(
            quantity: cartRow.quantity ?? 0,
            onIncrement: () => _guarded(context, () {
              context.read<CartBloc>().add(IncrementItemQuantity(rowKey!));
            }),
            onDecrement: () => _guarded(context, () {
              final quantity = cartRow!.quantity ?? 0;
              context.read<CartBloc>().add(
                    quantity > 1 ? DecrementItemQuantity(rowKey!) : RemoveItemFromCart(rowKey!),
                  );
            }),
          );
        }

        return _AddToCartBar(
          quantity: _draftQuantity,
          totalPrice: (widget.food.price ?? 0) * _draftQuantity,
          onIncrement: () => setState(() => _draftQuantity++),
          onDecrement: _draftQuantity > 1 ? () => setState(() => _draftQuantity--) : null,
          onAdd: () => _guarded(context, () {
            context.read<CartBloc>().add(AddItemToCart(CartItemEntity(
                  food: widget.food,
                  quantity: _draftQuantity,
                )));
            setState(() => _draftQuantity = 1);
          }),
        );
      },
    );
  }

  /// Выполняет действие только для авторизованного пользователя,
  /// иначе показывает диалог регистрации.
  void _guarded(BuildContext context, VoidCallback action) {
    if (UserHelper.isAuth()) {
      action();
      return;
    }
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
  }
}

/// Блюдо ещё не в корзине — количество + «Добавить · цена».
class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.quantity,
    required this.totalPrice,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAdd,
  });

  final int quantity;
  final int totalPrice;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuantityStepper(
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CtaButton(
            label: 'Добавить · ${FoodPriceFormatter.formatPriceWithCurrency(totalPrice)}',
            emphasized: true,
            onPressed: onAdd,
          ),
        ),
      ],
    );
  }
}

/// Состояние 3: конфигурация уже в корзине — правим её количество напрямую.
class _InCartBar extends StatelessWidget {
  const _InCartBar({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: context.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Уже в корзине',
                    style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Выберите другой гарнир,\nчтобы добавить ещё одну конфигурацию',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _QuantityStepper(
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }
}

/// Компактный степпер количества. Выключен, когда колбэки не заданы.
class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(icon: Icons.remove_rounded, onPressed: onDecrement),
          SizedBox(
            width: 36,
            child: Text(
              '$quantity',
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          _StepperButton(icon: Icons.add_rounded, onPressed: onIncrement),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onPressed});

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
            width: 46,
            height: 46,
            child: Icon(icon, size: 22, color: iconColor),
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.label,
    required this.emphasized,
    required this.onPressed,
  });

  final String label;

  /// true — основной акцентный стиль, false — приглушённый (шаг ещё не готов).
  final bool emphasized;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: emphasized
              ? context.colorScheme.primary
              : context.colorScheme.onSurface.withValues(alpha: 0.12),
          foregroundColor: emphasized
              ? context.colorScheme.onPrimary
              : context.colorScheme.onSurface.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        onPressed: onPressed,
        // FittedBox вместо ellipsis: цена на кнопке не должна обрезаться
        // («Добавить · 6…») — при нехватке места текст слегка ужимается.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: emphasized
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
