import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/common/food_card/export.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/cubit/garnish_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Нижняя панель страницы блюда.
///
/// Количество всегда принадлежит конкретной конфигурации «блюдо + гарнир»,
/// а не блюду вообще. Состояния панели:
/// 1. Гарнир обязателен, но не выбран — степпер выключен, CTA «Выберите гарнир».
/// 2. Конфигурация выбрана, но её нет в корзине — степпер черновика +
///    CTA «Добавить · полная цена × количество».
/// 3. Эта конфигурация уже в корзине — пометка «Уже в корзине», степпер
///    правит количество позиции корзины напрямую.
///
/// Смена гарнира в блоке выше мгновенно переключает панель на состояние
/// той конфигурации — так в одном флоу собираются «3× с рисом» и «1× с пюре».
class ProductDetailCartBar extends StatefulWidget {
  const ProductDetailCartBar({super.key, required this.food});

  final FoodEntity food;

  @override
  State<ProductDetailCartBar> createState() => _ProductDetailCartBarState();
}

class _ProductDetailCartBarState extends State<ProductDetailCartBar> {
  /// Черновое количество для конфигурации, которой ещё нет в корзине.
  int _draftQuantity = 1;

  /// Ключ конфигурации, для которой набрано [_draftQuantity]: количество
  /// принадлежит конфигурации, поэтому при смене гарнира черновик сбрасывается.
  String? _draftConfigKey;

  bool get _needsGarnish => widget.food.requiresGarnish ?? false;

  @override
  Widget build(BuildContext context) {
    if (!_needsGarnish) {
      return _buildForGarnish(context, garnish: null);
    }
    return BlocBuilder<GarnishCubit, GarnishState>(
      builder: (context, garnishState) {
        final selectedIndex = garnishState.selectedIndex;
        // Есть из чего выбирать, но выбор не сделан — просим выбрать гарнир.
        if (garnishState.items.isNotEmpty && selectedIndex == null) {
          return _SelectGarnishBar(
            onTap: () => context.read<GarnishCubit>().requestHighlight(),
          );
        }
        FoodEntity? garnish;
        if (selectedIndex != null && selectedIndex > 0 && selectedIndex <= garnishState.items.length) {
          garnish = garnishState.items[selectedIndex - 1];
        }
        return _buildForGarnish(context, garnish: garnish);
      },
    );
  }

  Widget _buildForGarnish(BuildContext context, {required FoodEntity? garnish}) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) => curr is CartLoaded || curr is CartInitial,
      builder: (context, state) {
        final configKey = CartItemEntity(food: widget.food, garnish: garnish).rowKey;
        if (configKey != _draftConfigKey) {
          _draftConfigKey = configKey;
          _draftQuantity = 1;
        }
        CartItemEntity? cartRow;
        if (state is CartLoaded && configKey != null) {
          cartRow = state.items.firstWhereOrNull((e) => e.rowKey == configKey);
        }

        if (cartRow != null) {
          return _InCartBar(
            quantity: cartRow.quantity ?? 0,
            onIncrement: () => _guarded(context, () {
              context.read<CartBloc>().add(IncrementItemQuantity(configKey!));
            }),
            onDecrement: () => _guarded(context, () {
              final quantity = cartRow!.quantity ?? 0;
              context.read<CartBloc>().add(
                    quantity > 1 ? DecrementItemQuantity(configKey!) : RemoveItemFromCart(configKey!),
                  );
            }),
          );
        }

        final unitPrice = (widget.food.price ?? 0) + (garnish?.price ?? 0);
        return _AddToCartBar(
          quantity: _draftQuantity,
          totalPrice: unitPrice * _draftQuantity,
          onIncrement: () => setState(() => _draftQuantity++),
          onDecrement: _draftQuantity > 1 ? () => setState(() => _draftQuantity--) : null,
          onAdd: () => _guarded(context, () {
            context.read<CartBloc>().add(AddItemToCart(CartItemEntity(
                  food: widget.food,
                  garnish: garnish,
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

/// Состояние 1: гарнир не выбран — степпер выключен, CTA ведёт к блоку выбора.
class _SelectGarnishBar extends StatelessWidget {
  const _SelectGarnishBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _QuantityStepper(quantity: 0),
        const SizedBox(width: 12),
        Expanded(
          child: _CtaButton(
            label: context.l10n.chooseGarnish,
            emphasized: false,
            onPressed: onTap,
          ),
        ),
      ],
    );
  }
}

/// Состояние 2: конфигурация собрана — количество + «Добавить · цена».
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
        child: Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: emphasized
                ? context.colorScheme.onPrimary
                : context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
