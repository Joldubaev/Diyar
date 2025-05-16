import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'info_dialog_widget.dart';

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
  final PaymentTypeDelivery paymentType;

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
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is CreateOrderLoaded) {
          if (paymentType == PaymentTypeDelivery.online) {
            context.router.push(PaymentsRoute(
              orderNumber: state.res,
              amount: totalOrderCost.toString(),
            ));
            Navigator.of(context).pop();
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    title: Text(
                      context.l10n.yourOrdersConfirm,
                      style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface),
                    ),
                    content: Text(
                      context.l10n.operatorContact,
                      style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface),
                      maxLines: 2,
                    ),
                    actions: [
                      SubmitButtonWidget(
                        textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
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
          context.read<CartBloc>().add(ClearCart());
        } else if (state is CreateOrderError) {
          showToast(state.message, isError: true);
        }
      },
      child: DraggableScrollableSheet(
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
                      textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.orderConfirmation,
          style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface),
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
        InfoDialogWidget(
          title: context.l10n.orderAmount,
          description: '${widget.totalPrice} сом',
        ),
        InfoDialogWidget(
          title: context.l10n.deliveryCost,
          description: '$deliveryPrice сом',
        ),
        InfoDialogWidget(
          title: context.l10n.total,
          description: '$totalOrderCost сом',
        ),
      ],
    );
  }

  void _onConfirmOrder(BuildContext context) {
    final orderCubit = context.read<OrderCubit>();
    orderCubit.createOrder(
      CreateOrderEntity(
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
            .map(
              (e) => FoodItemOrderEntity(
                dishId: '${e.food?.id}',
                name: e.food?.name ?? '',
                price: e.food?.price ?? 0,
                quantity: e.quantity ?? 1,
              ),
            )
            .toList(),
      ),
    );
  }
}
