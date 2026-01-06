import 'dart:developer' show log;
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/domain.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form/delivery_form_address_fields.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form/delivery_form_contact_fields.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form/delivery_form_payment_fields.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form/delivery_form_submit_button.dart';
import 'package:flutter/material.dart';

class DeliveryFormWidget extends StatefulWidget {
  const DeliveryFormWidget({
    super.key,
    required this.theme,
    required this.totalOrderCost,
    required this.onConfirm,
    required this.formKey,
    required this.userName,
    required this.phoneController,
    required this.addressController,
    required this.houseController,
    required this.entranceController,
    required this.floorController,
    required this.apartmentController,
    required this.intercomController,
    required this.sdachaController,
    required this.commentController,
    required this.paymentType,
    required this.onPaymentTypeChanged,
    this.onChangeAmountSelected,
  });

  final ThemeData theme;
  final int totalOrderCost;
  final VoidCallback onConfirm;
  final GlobalKey<FormState> formKey;
  final TextEditingController userName;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController houseController;
  final TextEditingController entranceController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  final TextEditingController intercomController;
  final TextEditingController sdachaController;
  final TextEditingController commentController;
  final PaymentTypeDelivery paymentType;
  final Function(PaymentTypeDelivery) onPaymentTypeChanged;
  final ValueChanged<ChangeAmountResult?>? onChangeAmountSelected;

  @override
  State<DeliveryFormWidget> createState() => _DeliveryFormWidgetState();
}

class _DeliveryFormWidgetState extends State<DeliveryFormWidget> {
  @override
  void initState() {
    super.initState();
    log("address2: ${widget.addressController.text}");
  }

  @override
  void didUpdateWidget(DeliveryFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paymentType != widget.paymentType) {
      if (widget.paymentType != PaymentTypeDelivery.cash) {
        widget.sdachaController.clear();
        widget.onChangeAmountSelected?.call(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DeliveryFormContactFields(
            theme: widget.theme,
            userName: widget.userName,
            phoneController: widget.phoneController,
          ),
          DeliveryFormAddressFields(
            theme: widget.theme,
            addressController: widget.addressController,
            houseController: widget.houseController,
            entranceController: widget.entranceController,
            floorController: widget.floorController,
            apartmentController: widget.apartmentController,
            intercomController: widget.intercomController,
          ),
          DeliveryFormPaymentFields(
            theme: widget.theme,
            paymentType: widget.paymentType,
            totalOrderCost: widget.totalOrderCost,
            sdachaController: widget.sdachaController,
            onChangeAmountSelected: widget.onChangeAmountSelected,
          ),
          CustomInputWidget(
            titleColor: widget.theme.colorScheme.onSurface,
            filledColor: widget.theme.colorScheme.surface,
            controller: widget.commentController,
            hintText: context.l10n.comment,
            validator: (val) => null,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          DeliveryFormSubmitButton(
            theme: widget.theme,
            totalOrderCost: widget.totalOrderCost,
            onConfirm: widget.onConfirm,
          ),
        ],
      ),
    );
  }
}
