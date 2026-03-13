import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/pick_up/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';

class PickupFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController userNameController;
  final TextEditingController commentController;
  final TextEditingController timeController;
  final TextEditingController bonusController;
  final VoidCallback onConfirmTap;
  final Function(BuildContext) onTimeSelect;
  final PaymentTypeDelivery currentPaymentType;
  final ValueChanged<PaymentTypeDelivery> onPaymentTypeChanged;
  final bool useBonus;
  final ValueChanged<bool> onBonusToggleChanged;
  final ValueChanged<double?> onBonusAmountChanged;
  final int totalPrice;

  const PickupFormWidget({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.userNameController,
    required this.commentController,
    required this.timeController,
    required this.bonusController,
    required this.onConfirmTap,
    required this.onTimeSelect,
    required this.currentPaymentType,
    required this.onPaymentTypeChanged,
    required this.useBonus,
    required this.onBonusToggleChanged,
    required this.onBonusAmountChanged,
    required this.totalPrice,
  });

  @override
  State<PickupFormWidget> createState() => _PickupFormWidgetState();
}

class _PickupFormWidgetState extends State<PickupFormWidget> {
  final FocusNode _bonusFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bonusFocusNode.addListener(_onBonusFocusChanged);
  }

  @override
  void dispose() {
    _bonusFocusNode.removeListener(_onBonusFocusChanged);
    _bonusFocusNode.dispose();
    super.dispose();
  }

  void _onBonusFocusChanged() {
    if (!_bonusFocusNode.hasFocus) {
      final value = widget.bonusController.text.trim();
      if (value.isEmpty) {
        widget.onBonusAmountChanged(null);
      } else {
        _onBonusAmountSubmitted(value);
      }
    }
  }

  void _onBonusAmountSubmitted(String value) {
    final parsedBonus = double.tryParse(value.replaceAll(',', '.'));

    if (parsedBonus != null && parsedBonus >= 0) {
      widget.onBonusAmountChanged(parsedBonus > 0 ? parsedBonus : null);
    } else if (value.isEmpty) {
      widget.onBonusAmountChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PickupUserNameField(
            controller: widget.userNameController,
            hintText: context.l10n.yourName,
          ),
          const SizedBox(height: 10),
          PickupPhoneField(
            controller: widget.phoneController,
            hintText: '+996 (___) __-__-__',
          ),
          const SizedBox(height: 10),
          PickupCommentField(
            controller: widget.commentController,
            hintText: context.l10n.comment,
          ),
          const SizedBox(height: 10),
          PickupTimeField(
            controller: widget.timeController,
            hintText: context.l10n.chooseTime,
            onTap: () => widget.onTimeSelect(context),
          ),
          const SizedBox(height: 16),
          PaymentTypeSelector(
            currentPaymentType: widget.currentPaymentType,
            onChanged: widget.onPaymentTypeChanged,
          ),
          const SizedBox(height: 16),
          PickupBonusSection(
            bonusController: widget.bonusController,
            bonusFocusNode: _bonusFocusNode,
            useBonus: widget.useBonus,
            onToggleChanged: widget.onBonusToggleChanged,
            onAmountChanged: widget.onBonusAmountChanged,
            onAmountSubmitted: _onBonusAmountSubmitted,
          ),
          const SizedBox(height: 16),
          PickupAddressInfo(l10n: context.l10n),
          const SizedBox(height: 10),
          PickupConfirmButton(
            onConfirmTap: widget.onConfirmTap,
          ),
        ],
      ),
    );
  }
}
