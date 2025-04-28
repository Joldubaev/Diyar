import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

Future<dynamic> showDeliveryOptionsDialog(
  BuildContext context,
  List<CartItemEntity> carts,
  int totalPrice,
) {
  final router = context.router;
  final l10n = context.l10n;

  return showDialog(
    context: context,
    builder: (dialogContext) {
      final navigator = Navigator.of(dialogContext);
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        title: Text(
          'Выберите способ Заказа',
          textAlign: TextAlign.center,
          style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                color: Theme.of(dialogContext).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: DeliveryOptionButton(
                    icon: Icons.delivery_dining,
                    label: l10n.delivery,
                    onTap: () async {
                      navigator.pop();
                      await router.push(OrderMapRoute(cart: carts, totalPrice: totalPrice));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DeliveryOptionButton(
                    icon: Icons.store,
                    label: l10n.pickup,
                    onTap: () async {
                      navigator.pop();
                      await router.push(PickupFormRoute(cart: carts, totalPrice: totalPrice));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [],
      );
    },
  );
}

class LoadedCartView extends StatefulWidget {
  final CartLoaded cartState;
  const LoadedCartView({super.key, required this.cartState});

  @override
  State<LoadedCartView> createState() => _LoadedCartViewState();
}

class _LoadedCartViewState extends State<LoadedCartView> {
  int _selectedCutleryCount = 0;

  void _showAppropriateDialog(BuildContext context, List<CartItemEntity> carts, int totalPrice) {
    final currentTime = DateTime.now();
    const startWorkTime = TimeOfDay(hour: 10, minute: 0);
    const endWorkTime = TimeOfDay(hour: 22, minute: 0);
    int timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

    final currentTimeOfDay = TimeOfDay.fromDateTime(currentTime);
    final currentTimeInMinutes = timeOfDayToMinutes(currentTimeOfDay);
    final startWorkTimeInMinutes = timeOfDayToMinutes(startWorkTime);
    final endWorkTimeInMinutes = timeOfDayToMinutes(endWorkTime);

    bool isShopClosed;
    if (startWorkTimeInMinutes < endWorkTimeInMinutes) {
      isShopClosed = currentTimeInMinutes < startWorkTimeInMinutes || currentTimeInMinutes > endWorkTimeInMinutes;
    } else {
      isShopClosed = currentTimeInMinutes < startWorkTimeInMinutes && currentTimeInMinutes > endWorkTimeInMinutes;
    }

    if (isShopClosed) {
      _showClosedAlertDialog(context, startWorkTime, endWorkTime);
    } else {
      showDeliveryOptionsDialog(context, carts, totalPrice);
    }
  }

  Future<dynamic> _showClosedAlertDialog(BuildContext context, TimeOfDay startWorkTime, TimeOfDay endWorkTime) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          title: Text(
            'Внимание!',
            style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                  color: Theme.of(dialogContext).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Мы работаем с  ${startWorkTime.hour} утро до  ${endWorkTime.hour} вечера. Пожалуйста, сделайте заказ позже.',
                style: Theme.of(dialogContext).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              SubmitButtonWidget(
                textStyle: Theme.of(dialogContext).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(dialogContext).colorScheme.onPrimary,
                    ),
                bgColor: Theme.of(dialogContext).colorScheme.primary,
                title: 'Закрыть',
                onTap: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carts = widget.cartState.items;
    final blocTotalPrice = widget.cartState.totalPrice;

    final containerPrice = carts.fold(
      0.0,
      (prevValue, element) => prevValue + ((element.food?.containerPrice?.toDouble() ?? 0.0) * (element.quantity ?? 0)),
    );
    final discountPercentage = 0.10;
    final itemsPrice = blocTotalPrice;
    final discountAmount = itemsPrice * discountPercentage;
    final discountedItemsPrice = itemsPrice - discountAmount;
    final finalTotalPrice = containerPrice + discountedItemsPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomScrollView(
        slivers: [
          CartItemsListWidget(items: carts),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: TotalPriceWidget(
              itemsPrice: itemsPrice,
              containerPrice: containerPrice,
              discountPercentage: discountPercentage,
              finalTotalPrice: finalTotalPrice,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: DishesWidget(
              initialCount: _selectedCutleryCount,
              onChanged: (newCount) {
                setState(() {
                  _selectedCutleryCount = newCount;
                });
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: SubmitButtonWidget(
                textStyle: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                bgColor: theme.colorScheme.primary,
                title: context.l10n.confirmOrder,
                onTap: () => _showAppropriateDialog(
                  context,
                  carts,
                  finalTotalPrice.toInt(),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
