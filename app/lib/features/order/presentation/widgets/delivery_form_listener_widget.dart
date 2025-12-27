import 'package:diyar/features/order/order.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет для обработки изменений состояния DeliveryFormCubit
/// Обновляет UI в зависимости от изменений paymentType и changeAmountResult
class DeliveryFormListenerWidget extends StatelessWidget {
  final Widget child;
  final DeliveryFormControllers controllers;

  const DeliveryFormListenerWidget({
    super.key,
    required this.child,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryFormCubit, DeliveryFormState>(
      listenWhen: (previous, current) {
        if (current is! DeliveryFormLoaded) return false;
        if (previous is! DeliveryFormLoaded) return true;

        return current.changeAmountResult != previous.changeAmountResult ||
            current.paymentType != previous.paymentType;
      },
      listener: (context, state) {
        if (state is! DeliveryFormLoaded) return;

        // Обновление текста поля сдачи (UI-обновление, не side-effect)
        if (state.changeAmountResult != null) {
          controllers.sdachaController.text =
              state.changeAmountResult!.getDisplayText(state.totalOrderCost);
        } else if (state.paymentType == PaymentTypeDelivery.online) {
          controllers.sdachaController.clear();
        }
      },
      child: child,
    );
  }
}

