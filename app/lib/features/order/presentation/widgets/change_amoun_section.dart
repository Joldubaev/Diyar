import 'package:diyar/core/components/components.dart';
import 'package:diyar/features/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'change_amount_dialog.dart';

class ChangeAmountSection extends StatelessWidget {
  final DeliveryFormControllers controllers;

  const ChangeAmountSection({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryFormCubit, DeliveryFormState>(
      builder: (context, state) {
        if (state is! DeliveryFormLoaded || state.paymentType != PaymentTypeDelivery.cash) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            CustomInputWidget(
              controller: controllers.sdachaController,
              hintText: 'С какой суммы понадобится сдача?',
              isReadOnly: true, // Только через диалог
              onTap: () => _showChangeDialog(context, state),
              // suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _showChangeDialog(BuildContext context, DeliveryFormLoaded state) async {
    // Вызываем диалог для выбора суммы сдачи
    final result = await ChangeAmountDialog.show(
      context: context,
      totalOrderCost: state.totalOrderCost,
    );
    if (result != null && context.mounted) {
      controllers.sdachaController.text = result.toString();
      context.read<DeliveryFormCubit>().setChangeAmount(result);
    }
  }
}
