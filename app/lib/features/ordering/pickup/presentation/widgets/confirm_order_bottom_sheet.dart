import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/ordering/delivery/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/ordering/pickup/pick_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmOrderBottomSheet extends StatelessWidget {
  final int totalPrice;
  final int totalOrderCost;
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
    required this.totalOrderCost,
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
        _handleStateChange(context, state);
      },
      child: ConfirmOrderBottomSheetContent(
        theme: theme,
        l10n: l10n,
        header: ConfirmOrderSheetHeader(l10n: l10n),
        details: _buildDetails(theme, l10n),
        isSubmitting: false,
        onConfirmTap: onConfirmTap,
      ),
    );
  }

  void _handleStateChange(BuildContext context, PickUpState state) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    if (state is CreatePickUpOrderLoaded) {
      if (paymentType == PaymentTypeDelivery.online) {
        _navigateToOnlinePayment(context, state);
      } else {
        _showSuccessDialog(context, theme, l10n);
      }
    } else if (state is CreatePickUpOrderError) {
      showToast(state.message, isError: true);
    }
  }

  void _navigateToOnlinePayment(BuildContext context, CreatePickUpOrderLoaded state) {
    context.router.push(
      OpenBankingPaymentRoute(
        orderNumber: state.message,
        amount: state.totalOrderCost,
        // amount: 1,
      ),
    );
    context.read<CartBloc>().add(ClearCart());
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showSuccessDialog(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    context.read<CartBloc>().add(ClearCart());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ConfirmOrderSuccessDialog(
        theme: theme,
        l10n: l10n,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          if (context.mounted) {
            Navigator.of(context).pop();
            context.router.pushAndPopUntil(
              const MainHomeRoute(),
              predicate: (route) => false,
            );
          }
        },
      ),
    );
  }

  Widget _buildDetails(ThemeData theme, AppLocalizations l10n) {
    final paymentMethodName = paymentType == PaymentTypeDelivery.cash ? l10n.payWithCash : l10n.payOnline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfirmOrderInfoRow(
          title: l10n.name,
          description: userName.isNotEmpty ? userName : l10n.notSpecified,
        ),
        ConfirmOrderInfoRow(
          title: l10n.phone,
          description: userPhone,
        ),
        if (time.isNotEmpty)
          ConfirmOrderInfoRow(
            title: l10n.readyTime,
            description: time,
          ),
        ConfirmOrderInfoRow(
          title: l10n.paymentMethod,
          description: paymentMethodName,
        ),
        ConfirmOrderInfoRow(
          title: l10n.orderAmount,
          description: '$totalPrice сом',
        ),
        ConfirmOrderInfoRow(
          title: l10n.totalWithoutBonus,
          description: '$totalPrice сом',
        ),
        if (bonusAmount != null && bonusAmount! > 0) ...[
          ConfirmOrderInfoRow(
            title: l10n.bonusDeduction,
            description: '${bonusAmount!.toStringAsFixed(0)} сом',
          ),
          ConfirmOrderInfoRow(
            title: l10n.totalWithBonus,
            description: '$totalOrderCost сом',
          ),
        ],
        if (comment.isNotEmpty)
          ConfirmOrderCommentSection(
            comment: comment,
            theme: theme,
            l10n: l10n,
          ),
      ],
    );
  }
}
