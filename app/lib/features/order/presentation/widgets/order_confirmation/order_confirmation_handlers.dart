import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/presentation/cubit/order_cubit.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form_controllers.dart';
import 'package:diyar/features/order/presentation/widgets/order_confirmation/order_confirmation_helper.dart';
import 'package:diyar/features/order/presentation/widgets/save_template_dialog.dart';
import 'package:diyar/features/templates/presentation/cubit/templates_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Обработчики для bottom sheet подтверждения заказа
class OrderConfirmationHandlers {
  /// Обработчик сохранения шаблона
  static Future<void> handleSaveTemplate({
    required BuildContext context,
    required ThemeData theme,
    required TextEditingController addressController,
    required TextEditingController houseController,
    required TextEditingController commentController,
    required TextEditingController entranceController,
    required TextEditingController floorController,
    required TextEditingController intercomController,
    required TextEditingController apartmentController,
    required TextEditingController userName,
    required TextEditingController phoneController,
    required int deliveryPrice,
    String? region,
  }) async {
    final templatesCubit = context.read<TemplatesListCubit>();

    final defaultName = addressController.text.isNotEmpty
        ? addressController.text
        : 'Новый адрес';

    final templateName = await SaveTemplateDialog.show(
      context: context,
      defaultName: defaultName,
      theme: theme,
    );

    if (templateName == null || templateName.isEmpty) {
      return;
    }

    final addressData = OrderConfirmationHelper.createAddressEntity(
      addressController: addressController,
      houseController: houseController,
      commentController: commentController,
      entranceController: entranceController,
      floorController: floorController,
      intercomController: intercomController,
      apartmentController: apartmentController,
      region: region,
    );

    final contactInfo = OrderConfirmationHelper.createContactInfoEntity(
      userName: userName,
      phoneController: phoneController,
    );

    templatesCubit.createTemplateFromOrder(
      templateName: templateName,
      addressData: addressData,
      contactInfo: contactInfo,
      price: deliveryPrice,
      onSuccess: () {
        showToast('Адрес успешно сохранен в шаблоны', isError: false);
      },
      onError: (errorMessage) {
        showToast(errorMessage, isError: true);
      },
    );
  }

  /// Обработчик подтверждения заказа
  static void handleConfirmOrder({
    required BuildContext context,
    required List<CartItemEntity> cart,
    required int totalPrice,
    required int deliveryPrice,
    required int dishCount,
    required int sdacha,
    required PaymentTypeDelivery paymentType,
    required int totalOrderCost,
    required DeliveryFormControllers controllers,
    String? region,
  }) {
    final orderCubit = context.read<OrderCubit>();

    final orderEntity = OrderConfirmationHelper.createOrderEntity(
      cart: cart,
      totalPrice: totalPrice,
      deliveryPrice: deliveryPrice,
      dishCount: dishCount,
      sdacha: sdacha,
      paymentType: paymentType,
      controllers: controllers,
      region: region,
    );

    log(
      'Creating order with contactInfo: userName="${orderEntity.contactInfo.userName}", '
      'userPhone="${orderEntity.contactInfo.userPhone}"',
    );

    orderCubit.createOrder(
      orderEntity,
      onSuccess: (orderNumber) {
        _handleOrderSuccess(
          context: context,
          orderNumber: orderNumber,
          paymentType: paymentType,
          totalOrderCost: totalOrderCost,
        );
      },
      onError: (errorMessage) {
        showToast(errorMessage, isError: true);
      },
    );
  }

  static void _handleOrderSuccess({
    required BuildContext context,
    required String? orderNumber,
    required PaymentTypeDelivery paymentType,
    required int totalOrderCost,
  }) {
    if (paymentType == PaymentTypeDelivery.online) {
      context.router.push(
        PaymentsRoute(
          orderNumber: orderNumber,
          amount: totalOrderCost.toString(),
        ),
      );
      Navigator.of(context).pop();
    } else {
      _showCashPaymentDialog(context);
    }
    context.read<CartBloc>().add(ClearCart());
  }

  static void _showCashPaymentDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(
              context.l10n.yourOrdersConfirm,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            content: Text(
              context.l10n.operatorContact,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
            ),
            actions: [
              SubmitButtonWidget(
                textStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                title: context.l10n.ok,
                bgColor: AppColors.green,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                  context.router.pushAndPopUntil(
                    const MainRoute(),
                    predicate: (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

