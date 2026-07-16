import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/common/food_card/export.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/presentation/cubit/garnish_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Шит выбора гарнира — единственная точка добавления блюда
/// с [FoodEntity.requiresGarnish] в корзину: гарнир + количество +
/// подтверждение в одном месте, итоговая цена на кнопке.
///
/// Возвращает `true`, если блюдо добавлено в корзину.
abstract final class GarnishPickerSheet {
  static Future<bool?> show(BuildContext context, FoodEntity food) {
    final cartBloc = context.read<CartBloc>();
    return AppBottomSheet.showBottomSheet<bool>(
      context,
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cartBloc),
          BlocProvider(create: (_) => sl<GarnishCubit>()..load()),
        ],
        child: _GarnishPickerContent(food: food),
      ),
      initialChildSize: 0.65,
    );
  }
}

class _GarnishPickerContent extends StatelessWidget {
  const _GarnishPickerContent({required this.food});

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GarnishCubit, GarnishState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final items = state.items;
        final selectedIndex = state.selectedIndex;
        // Список пуст/не загрузился — не блокируем заказ, даём добавить как есть.
        final requiresChoice = items.isNotEmpty;
        final canConfirm = !requiresChoice || selectedIndex != null;

        FoodEntity? garnish;
        if (selectedIndex != null && selectedIndex > 0 && selectedIndex <= items.length) {
          garnish = items[selectedIndex - 1];
        }
        // Цена одной порции: блюдо + выбранный гарнир. Количество здесь
        // не выбирается — им управляет корзина, повторные добавления
        // с тем же гарниром сливаются в одну позицию.
        final totalPrice = (food.price ?? 0) + (garnish?.price ?? 0);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                food.name ?? '',
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (requiresChoice) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.chooseGarnish,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    _RequiredBadge(done: selectedIndex != null),
                  ],
                ),
                const SizedBox(height: 12),
                _GarnishOptionRow(
                  title: context.l10n.withoutGarnish,
                  selected: selectedIndex == 0,
                  onTap: () => context.read<GarnishCubit>().select(0),
                ),
                for (var i = 0; i < items.length; i++)
                  _GarnishOptionRow(
                    title: items[i].name ?? '',
                    imageUrl: items[i].imageUrlForList,
                    price: items[i].price,
                    selected: selectedIndex == i + 1,
                    onTap: () => context.read<GarnishCubit>().select(i + 1),
                  ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  onPressed: canConfirm ? () => _confirm(context, garnish) : null,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      canConfirm
                          ? 'В корзину · ${FoodPriceFormatter.formatPriceWithCurrency(totalPrice)}'
                          : context.l10n.chooseGarnish,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: canConfirm
                            ? context.colorScheme.onPrimary
                            : context.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirm(BuildContext context, FoodEntity? garnish) {
    context.read<CartBloc>().add(AddItemToCart(CartItemEntity(
          food: food,
          garnish: garnish,
          quantity: 1,
        )));
    Navigator.of(context).pop(true);
  }
}

/// Бейдж «Обязательно» → «✓ Выбрано».
class _RequiredBadge extends StatelessWidget {
  const _RequiredBadge({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    final color = done ? Colors.green.shade700 : context.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done) ...[
            Icon(Icons.check, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            done ? 'Выбрано' : 'Обязательно',
            style: context.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Строка-вариант: радио-индикатор, миниатюра, название, «+цена».
class _GarnishOptionRow extends StatelessWidget {
  const _GarnishOptionRow({
    required this.title,
    required this.selected,
    required this.onTap,
    this.imageUrl,
    this.price,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final String? imageUrl;
  final int? price;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: selected ? scheme.primary.withValues(alpha: 0.08) : scheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.5),
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                _RadioIndicator(selected: selected),
                const SizedBox(width: 12),
                _Thumbnail(imageUrl: imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  price != null && price! > 0 ? '+$price сом' : 'бесплатно',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? scheme.primary : scheme.outlineVariant,
          width: selected ? 7 : 2,
        ),
      ),
    );
  }
}

/// Круглая миниатюра гарнира; для «Без гарнира» — иконка приборов.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    const size = 40.0;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        ),
        child: Icon(Icons.restaurant, size: 20, color: scheme.onSurfaceVariant),
      );
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        memCacheWidth: 120,
        fit: BoxFit.cover,
        placeholder: (_, __) => const SizedBox(
          width: size,
          height: size,
          child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
        ),
        errorWidget: (_, __, ___) => Container(
          width: size,
          height: size,
          color: scheme.surfaceContainerHighest,
          child: Icon(Icons.restaurant, size: 20, color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
