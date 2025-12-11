import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/cart/presentation/utils/cart_dialog_utils.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/settings/domain/entities/timer_entites.dart';
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
    context.read<SettingsCubit>().getTimer();
    _calculatePrices(null);
  }

  @override
  void didUpdateWidget(LoadedCartView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartState.totalPrice != oldWidget.cartState.totalPrice) {
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
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, menuState) {
                TimerEntites? timerFromState;
                bool isLoadingTimer = false;
                String? timerErrorMsg;

                if (menuState is TimerLoaded) {
                  timerFromState = menuState.timer;
                } else if (menuState is TimerLoading) {
                  isLoadingTimer = true;
                } else if (menuState is TimerError) {
                  timerErrorMsg = menuState.message;
                }

                if (isLoadingTimer) {
                  return const SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: CircularProgressIndicator(),
                    )),
                  );
                }

                if (timerErrorMsg != null && timerFromState == null) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          timerErrorMsg,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: SubmitButtonWidget(
                      textStyle: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      bgColor: theme.colorScheme.primary,
                      title: context.l10n.confirmOrder,
                      onTap: () {
                        if (timerFromState == null && timerErrorMsg != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(timerErrorMsg),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                          return;
                        }

                        if (timerFromState == null || timerFromState.serverTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Не удалось получить актуальное время работы магазина. Попробуйте позже."),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                          return;
                        }

                        showOrderDialogs(
                          dishCount: _selectedCutleryCount,
                          context: context,
                          cartItems: carts,
                          totalPrice: _dynamicFinalTotalPrice.toInt(),
                          startWorkTimeString: timerFromState.startTime.toString(),
                          endWorkTimeString: '00:00',
                          serverTimeString: timerFromState.serverTime,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
