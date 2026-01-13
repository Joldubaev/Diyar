import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/dialogs/cart_dialog_utils.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cutlery_cubit.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_price_cubit.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/settings/domain/entities/timer_entites.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Секция таймера и кнопки подтверждения заказа
class CartTimerSection extends StatelessWidget {
  final List<CartItemEntity> cartItems;

  const CartTimerSection({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartPriceCubit, CartPriceState>(
      builder: (context, priceState) {
        if (priceState is! CartPriceCalculated) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return CartTimerWidget(
          confirmButtonTitle: context.l10n.confirmOrder,
          onConfirm: () => _handleOrderConfirmation(
            context,
            priceState,
          ),
        );
      },
    );
  }

  void _handleOrderConfirmation(
    BuildContext context,
    CartPriceCalculated priceState,
  ) {
    final timerState = context.read<SettingsCubit>().state;
    final timer = _getTimerFromState(timerState);

    if (timer?.serverTime == null) {
      SnackBarMessage().showErrorSnackBar(
        message: "Не удалось получить актуальное время работы магазина. Попробуйте позже.",
        context: context,
      );
      return;
    }

    final cutleryCount = _getCutleryCount(context);
    final totalPrice = priceState.subtotalPrice.toInt();

    showOrderDialogs(
      dishCount: cutleryCount,
      context: context,
      cartItems: cartItems,
      totalPrice: totalPrice,
      // startWorkTimeString: timer!.startTime.toString(),
      startWorkTimeString: '00:00',
      // endWorkTimeString: timer.endTime.toString(),
      endWorkTimeString: '00:00',
      serverTimeString: timer!.serverTime!.toString(),
      onDeliveryTap: () async {
        // Используем use case для получения актуальных шаблонов
        final getTemplatesUseCase = sl<GetTemplatesUseCase>();
        final templatesResult = await getTemplatesUseCase();

        templatesResult.fold(
          // При ошибке - переходим сразу к карте
          (_) {
            context.router.push(
              OrderMapRoute(
                cart: cartItems,
                totalPrice: totalPrice,
                dishCount: cutleryCount,
              ),
            );
          },
          (templates) {
            // Если есть шаблоны - показываем их, иначе карту
            if (templates.isNotEmpty) {
              context.router.push(TemplatesRoute());
            } else {
              context.router.push(
                OrderMapRoute(
                  cart: cartItems,
                  totalPrice: totalPrice,
                  dishCount: cutleryCount,
                ),
              );
            }
          },
        );
      },
      onPickupTap: () {
        context.router.push(
          PickupFormRoute(
            cart: cartItems,
            totalPrice: totalPrice,
            dishCount: cutleryCount,
          ),
        );
      },
    );
  }

  TimerEntites? _getTimerFromState(SettingsState state) {
    if (state is TimerLoaded) {
      return state.timer;
    }
    return null;
  }

  int _getCutleryCount(BuildContext context) {
    final cutleryState = context.read<CartCutleryCubit>().state;
    if (cutleryState is CartCutlerySet) {
      return cutleryState.count;
    }
    return 0;
  }
}
