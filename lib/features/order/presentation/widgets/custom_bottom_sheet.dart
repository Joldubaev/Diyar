import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/presentation/presentation.dart';
import 'package:diyar/features/order/data/models/create_payment_model.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/features/order/presentation/pages/delivery_page.dart';
import 'package:diyar/features/order/presentation/widgets/custom_dialog_widget.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomSheet extends StatelessWidget {
  final ThemeData theme;
  final DeliveryFormPage widget;
  final int deliveryPrice;
  final int totalOrderCost;
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
  final PaymentMethod paymentType;

  const CustomBottomSheet({
    super.key,
    required this.theme,
    required this.widget,
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
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.35,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 15),
              _buildDetails(context),
              const Divider(),
              BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  return SubmitButtonWidget(
                    textStyle: theme.textTheme.bodyMedium!
                        .copyWith(color: theme.colorScheme.onPrimary),
                    title: context.l10n.confirm,
                    bgColor: AppColors.green,
                    isLoading: state is CreateOrderLoading,
                    onTap: () => _onConfirmOrder(context),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.orderConfirmation,
          style: theme.textTheme.bodyLarge!
              .copyWith(color: theme.colorScheme.onSurface),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDialogWidget(
          title: context.l10n.orderAmount,
          description: '${widget.totalPrice} сом',
        ),
        CustomDialogWidget(
          title: context.l10n.deliveryCost,
          description: '$deliveryPrice сом',
        ),
        CustomDialogWidget(
          title: context.l10n.total,
          description: '$totalOrderCost сом',
        ),
      ],
    );
  }

  void _onConfirmOrder(BuildContext context) async {
    final orderCubit = context.read<OrderCubit>();

    final result = await orderCubit.createOrder(
      CreateOrderModel(
        userPhone: phoneController.text,
        userName: userName.text,
        address: addressController.text,
        comment: commentController.text,
        price: widget.totalPrice,
        deliveryPrice: deliveryPrice,
        houseNumber: houseController.text,
        kvOffice: apartmentController.text,
        intercom: intercomController.text,
        floor: floorController.text,
        entrance: entranceController.text,
        paymentMethod: paymentType.name,
        dishesCount: widget.dishCount,
        sdacha: sdacha,
        region: region,
        foods: widget.cart
            .map((e) => OrderFoodItem(
                  name: e.food?.name ?? '',
                  price: e.food?.price ?? 0,
                  quantity: e.quantity ?? 1,
                ))
            .toList(),
      ),
    );

    result.fold(
      (failure) {
        log("❌ Ошибка при создании заказа: ${failure.message}");
      },
      (orderNumber) {
        log("✅ Заказ создан. Номер: $orderNumber");

        if (context.mounted) {
          context.read<CartCubit>().clearCart();
          context.read<CartCubit>().dishCount = 0;
        }

        if (paymentType == PaymentMethod.cash) {
          _showOrderConfirmationDialog(context);
        } else {
          _startOnlinePayment(context, orderNumber);
        }
      },
    );
  }

  void _showOrderConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.yourOrdersConfirm),
          content: Text(context.l10n.operatorContact),
          actions: [
            SubmitButtonWidget(
              title: context.l10n.ok,
              bgColor: AppColors.green,
              onTap: () {
                context.router.pushAndPopUntil(
                  const MainRoute(),
                  predicate: (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _startOnlinePayment(BuildContext context, String orderNumber) async {
    final payment = PaymentModel(
      amount: widget.totalPrice + deliveryPrice,
      orderNumber: int.tryParse(orderNumber) ?? 0,
      phone: phoneController.text,
      status: "pending",
      userName: userName.text,
    );

    final paymentResult = await context.read<OrderCubit>().getPayment(payment);

    paymentResult.fold(
      (failure) {
        log("❌ Ошибка получения ссылки для оплаты: ${failure.message}");
      },
      (paymentUrl) {
        if (paymentUrl.isNotEmpty) {
          log("🔗 Открываем ссылку: $paymentUrl");
          context.router.push(OnlainPaymentRoute(paymentUrl: paymentUrl));
        } else {
          log("❌ Ошибка: Ссылка на оплату не получена");
        }
      },
    );
  }
}
