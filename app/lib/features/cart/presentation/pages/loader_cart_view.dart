import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadedCartView extends StatefulWidget {
  final CartLoaded cartState;
  const LoadedCartView({super.key, required this.cartState});

  @override
  State<LoadedCartView> createState() => _LoadedCartViewState();
}

class _LoadedCartViewState extends State<LoadedCartView> {
  int _selectedCutleryCount = 0;
  double _dynamicFinalTotalPrice = 0.0;
  double _discountPercentageForDisplay = 0.0;
  double _calculatedMonetaryDiscount = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<HomeContentCubit>().getSales();
    _calculatePrices(null);
  }

  @override
  void didUpdateWidget(LoadedCartView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Проверяем, изменилась ли общая стоимость товаров в корзине
    if (widget.cartState.totalPrice != oldWidget.cartState.totalPrice) {
      // Пересчитываем цены, используя текущий процент скидки (передаем null,
      // чтобы _calculatePrices использовал _discountPercentageForDisplay)
      _calculatePrices(null);
    }
  }

  void _calculatePrices(double? saleDiscountValue) {
    final double itemsPrice = widget.cartState.totalPrice.toDouble();
    final double containerPrice = widget.cartState.items.fold(
      0.0,
      (prevValue, element) => prevValue + ((element.food?.containerPrice?.toDouble() ?? 0.0) * (element.quantity ?? 0)),
    );

    double currentDiscountRate = 0.0;
    double newDiscountPercentageForDisplay = 0.0;

    if (saleDiscountValue != null) {
      newDiscountPercentageForDisplay = saleDiscountValue.toDouble();
      currentDiscountRate = newDiscountPercentageForDisplay / 100.0;
    } else {
      // Если saleDiscountValue равен null (например, при обновлении корзины),
      // используем уже установленный процент скидки
      newDiscountPercentageForDisplay = _discountPercentageForDisplay;
      currentDiscountRate = _discountPercentageForDisplay / 100.0;
    }

    final double actualMonetaryDiscount = itemsPrice * currentDiscountRate;
    final double discountedItemsPrice = itemsPrice - actualMonetaryDiscount;

    if (mounted) {
      setState(() {
        _dynamicFinalTotalPrice = containerPrice + discountedItemsPrice;
        _discountPercentageForDisplay = newDiscountPercentageForDisplay;
        _calculatedMonetaryDiscount = actualMonetaryDiscount;
      });
    }
  }

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
      showDeliveryOptionsBottomSheet(context, carts, totalPrice);
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
                'Мы работаем с  ${startWorkTime.hour} утра  до  ${endWorkTime.hour} вечера. Пожалуйста, сделайте заказ позже.',
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

    final double itemsPriceForWidget = widget.cartState.totalPrice.toDouble();
    final double containerPriceForWidget = widget.cartState.items.fold(
      0.0,
      (prevValue, element) => prevValue + ((element.food?.containerPrice?.toDouble() ?? 0.0) * (element.quantity ?? 0)),
    );

    return BlocListener<HomeContentCubit, HomeContentState>(
      listener: (context, state) {
        if (state is GetSalesLoaded && state.sales.isNotEmpty) {
          final saleDiscount = state.sales.first.discount;
          _calculatePrices(saleDiscount?.toDouble());
        } else if (state is GetSalesLoaded && state.sales.isEmpty) {
          _calculatePrices(null);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomScrollView(
          slivers: [
            CartItemsListWidget(items: carts),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: TotalPriceWidget(
                itemsPrice: itemsPriceForWidget,
                containerPrice: containerPriceForWidget,
                discountRatePercentage: _discountPercentageForDisplay,
                monetaryDiscountAmount: _calculatedMonetaryDiscount,
                finalTotalPrice: _dynamicFinalTotalPrice,
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
                    _dynamicFinalTotalPrice.toInt(),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showDeliveryOptionsBottomSheet(
  BuildContext context,
  List<CartItemEntity> carts,
  int totalPrice,
) {
  final router = context.router;
  final l10n = context.l10n;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.38,
        minChildSize: 0.25,
        maxChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                // Можно добавить SVG или PNG иллюстрацию сверху
                // Center(child: Image.asset('assets/images/order_type.png', height: 60)),
                Text(
                  'Как оформить заказ?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Выберите удобный способ получения заказа',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          router.push(OrderMapRoute(cart: carts, totalPrice: totalPrice));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.delivery_dining, size: 32, color: Theme.of(context).colorScheme.onPrimary),
                            const SizedBox(height: 8),
                            Text(
                              l10n.delivery,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          router.push(PickupFormRoute(cart: carts, totalPrice: totalPrice));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.store, size: 32, color: Theme.of(context).colorScheme.onSecondary),
                            const SizedBox(height: 8),
                            Text(
                              l10n.pickup,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    },
  );
}
