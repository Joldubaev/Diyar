import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/order/presentation/pages/delivery_page.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form_controllers.dart';
import 'package:diyar/features/order/presentation/widgets/order_confirmation/order_confirmation_bottom_sheet.dart';
import 'package:diyar/features/order/presentation/widgets/order_confirmation/order_confirmation_handlers.dart';
import 'package:flutter/material.dart';

/// Bottom sheet для подтверждения заказа (legacy wrapper)
/// Использует новые компоненты из order_confirmation/
class CustomBottomSheet extends StatelessWidget {
  final ThemeData theme;
  final DeliveryFormPage widget;
  final int deliveryPrice;
  final int totalOrderCost;
  final int dishCount;
  final int sdacha;
  final String? region;
  final TextEditingController phoneController;
  final TextEditingController userName;
  final TextEditingController addressController;
  final TextEditingController commentController;
  final TextEditingController houseController;
  final TextEditingController apartmentController;
  final TextEditingController intercomController;
  final TextEditingController floorController;
  final TextEditingController entranceController;
  final PaymentTypeDelivery paymentType;

  const CustomBottomSheet({
    super.key,
    required this.theme,
    required this.widget,
    required this.dishCount,
    required this.deliveryPrice,
    required this.totalOrderCost,
    required this.sdacha,
    required this.phoneController,
    required this.userName,
    required this.addressController,
    required this.commentController,
    required this.houseController,
    required this.apartmentController,
    required this.intercomController,
    required this.floorController,
    required this.entranceController,
    required this.paymentType,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = DeliveryFormControllers(
      initialPhone: phoneController.text,
      initialUserName: userName.text,
      initialAddress: addressController.text,
      initialHouseNumber: houseController.text,
    );

    // Обновляем контроллеры из переданных значений
    controllers.phoneController.text = phoneController.text;
    controllers.userName.text = userName.text;
    controllers.addressController.text = addressController.text;
    controllers.houseController.text = houseController.text;
    controllers.commentController.text = commentController.text;
    controllers.apartmentController.text = apartmentController.text;
    controllers.intercomController.text = intercomController.text;
    controllers.floorController.text = floorController.text;
    controllers.entranceController.text = entranceController.text;

    return OrderConfirmationBottomSheet(
      theme: theme,
      totalPrice: widget.totalPrice,
      deliveryPrice: deliveryPrice,
      totalOrderCost: totalOrderCost,
      onConfirmOrder: () {
        OrderConfirmationHandlers.handleConfirmOrder(
          context: context,
          cart: widget.cart,
          totalPrice: widget.totalPrice,
          deliveryPrice: deliveryPrice,
          dishCount: dishCount,
          sdacha: sdacha,
          paymentType: paymentType,
          totalOrderCost: totalOrderCost,
          controllers: controllers,
          region: region,
        );
      },
      onSaveTemplate: () {
        OrderConfirmationHandlers.handleSaveTemplate(
          context: context,
          theme: theme,
          addressController: addressController,
          houseController: houseController,
          commentController: commentController,
          entranceController: entranceController,
          floorController: floorController,
          intercomController: intercomController,
          apartmentController: apartmentController,
          userName: userName,
          phoneController: phoneController,
          deliveryPrice: deliveryPrice,
          region: region,
        );
      },
    );
  }
}
