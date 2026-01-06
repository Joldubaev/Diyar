import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/domain.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/order/presentation/widgets/change_amount_dialog.dart';
import 'package:flutter/material.dart';

/// Поля оплаты формы доставки
class DeliveryFormPaymentFields extends StatelessWidget {
  final ThemeData theme;
  final PaymentTypeDelivery paymentType;
  final int totalOrderCost;
  final TextEditingController sdachaController;
  final ValueChanged<ChangeAmountResult?>? onChangeAmountSelected;

  const DeliveryFormPaymentFields({
    super.key,
    required this.theme,
    required this.paymentType,
    required this.totalOrderCost,
    required this.sdachaController,
    this.onChangeAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (paymentType != PaymentTypeDelivery.cash) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CustomInputWidget(
          titleColor: theme.colorScheme.onSurface,
          filledColor: theme.colorScheme.surface,
          inputType: TextInputType.number,
          controller: sdachaController,
          hintText: context.l10n.change,
          isReadOnly: true,
          onTap: () async {
            final result = await ChangeAmountDialog.show(
              context: context,
              totalOrderCost: totalOrderCost,
            );
            if (result != null && context.mounted) {
              sdachaController.text = result.getDisplayText(totalOrderCost);
              onChangeAmountSelected?.call(result);
            }
          },
          validator: (value) {
            if (paymentType == PaymentTypeDelivery.cash) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, выберите сумму сдачи';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

