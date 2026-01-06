import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:flutter/material.dart';

/// Утилита для показа bottom sheet подтверждения заказа
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
    final sdachaValue = state.changeAmountResult?.toChangeAmount() ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return CustomBottomSheet(
          dishCount: dishCount,
          region: '',
          theme: Theme.of(context),
          widget: DeliveryFormPage(
            cart: cart,
            dishCount: dishCount,
            totalPrice: totalPrice,
            deliveryPrice: deliveryPrice,
          ),
          deliveryPrice: deliveryPrice.toInt(),
          totalOrderCost: state.totalOrderCost,
          phoneController: controllers.phoneController,
          userName: controllers.userName,
          addressController: controllers.addressController,
          commentController: controllers.commentController,
          houseController: controllers.houseController,
          apartmentController: controllers.apartmentController,
          intercomController: controllers.intercomController,
          floorController: controllers.floorController,
          entranceController: controllers.entranceController,
          paymentType: state.paymentType,
          sdacha: sdachaValue,
        );
      },
    );
  }
}

