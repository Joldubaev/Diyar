import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/features/order/presentation/widgets/info_dialog_widget.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmOrderBottomSheet extends StatelessWidget {
  final int totalPrice;
  final double? bonusAmount;
  final String userName;
  final String userPhone;
  final String time;
  final String comment;
  final PaymentTypeDelivery paymentType;
  final VoidCallback onConfirmTap;

  const ConfirmOrderBottomSheet({
    super.key,
    required this.totalPrice,
    this.bonusAmount,
    required this.userName,
    required this.userPhone,
    required this.time,
    required this.comment,
    required this.paymentType,
    required this.onConfirmTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocListener<PickUpCubit, PickUpState>(
      listener: (context, state) {
        if (state is CreatePickUpOrderLoaded) {
          context.read<CartBloc>().add(ClearCart());
          if (paymentType == PaymentTypeDelivery.online) {
            context.router.push(
              PaymentsRoute(
                orderNumber: state.message,
                amount: totalPrice.toString(),
              ),
            );
            Navigator.of(context).pop();
          } else {
            context.read<CartBloc>().add(ClearCart());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    title: Text(
                      l10n.yourOrdersConfirm,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    content: Text(
                      l10n.operatorContact,
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
                        title: l10n.ok,
                        bgColor: AppColors.green,
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pop();
                          context.router.pushAndPopUntil(
                            const MainHomeRoute(),
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
        } else if (state is CreatePickUpOrderError) {
          showToast(state.message, isError: true);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.8,
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
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 15),
                  _buildDetails(context),
                  const Divider(),
                  const SizedBox(height: 12),
                  BlocBuilder<PickUpCubit, PickUpState>(
                    builder: (context, currentState) {
                      final isSubmitting = currentState is CreatePickUpOrderLoading;
                      return SubmitButtonWidget(
                        textStyle: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        title: l10n.confirm,
                        bgColor: AppColors.green,
                        isLoading: isSubmitting,
                        onTap: onConfirmTap,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.orderConfirmation,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    // Определяем название способа оплаты
    final paymentMethodName = paymentType == PaymentTypeDelivery.cash ? l10n.payWithCash : l10n.payOnline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoDialogWidget(
          title: 'Имя',
          description: userName.isNotEmpty ? userName : 'Не указано',
        ),
        InfoDialogWidget(
          title: 'Телефон',
          description: userPhone,
        ),
        if (time.isNotEmpty)
          InfoDialogWidget(
            title: 'Время готовности',
            description: time,
          ),
        InfoDialogWidget(
          title: 'Способ оплаты',
          description: paymentMethodName,
        ),
        InfoDialogWidget(
          title: l10n.orderAmount,
          description: '$totalPrice сом',
        ),
        if (bonusAmount != null && bonusAmount! > 0)
          InfoDialogWidget(
            title: 'Будет списано бонусов',
            description: bonusAmount!.toStringAsFixed(0),
          ),
        if (comment.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Комментарий',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
