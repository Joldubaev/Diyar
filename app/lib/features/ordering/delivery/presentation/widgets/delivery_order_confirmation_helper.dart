import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/ordering/delivery/order.dart';
import 'package:diyar/features/templates/presentation/cubit/templates_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Утилита для показа bottom sheet подтверждения заказа
/// Адаптирована для работы с текущей логикой (int? changeAmount)
class DeliveryOrderConfirmationHelper {
  /// Показывает bottom sheet для подтверждения заказа
  static void showOrderConfirmationSheet({
    required BuildContext context,
    required DeliveryFormLoaded state,
    required List<CartItemEntity> cart,
    required int dishCount,
    required int totalPrice,
    required double deliveryPrice,
    required DeliveryFormControllers controllers,
  }) {
    final deliveryFormCubit = context.read<DeliveryFormCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: deliveryFormCubit),
          BlocProvider(create: (_) => di.sl<TemplatesListCubit>()),
        ],
        child: CustomBottomSheet(
          cart: cart,
        ),
      ),
    );
  }
}
