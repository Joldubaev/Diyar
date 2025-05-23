import 'package:diyar/core/components/input/phone_number.dart';
import 'package:diyar/features/order/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PickupFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController userNameController;
  final TextEditingController commentController;
  final TextEditingController timeController;
  final VoidCallback onConfirmTap;
  final Function(BuildContext) onTimeSelect;
  final PaymentTypeDelivery currentPaymentType;
  final ValueChanged<PaymentTypeDelivery> onPaymentTypeChanged;

  const PickupFormWidget({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.userNameController,
    required this.commentController,
    required this.timeController,
    required this.onConfirmTap,
    required this.onTimeSelect,
    required this.currentPaymentType,
    required this.onPaymentTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomInputWidget(
            titleColor: theme.colorScheme.onSurface,
            filledColor: theme.colorScheme.surface,
            controller: userNameController,
            hintText: l10n.yourName,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Введите имя';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          PhoneNumberMask(
            hintText: '+996 (___) __-__-__',
            textController: phoneController,
            hint: l10n.phone,
            formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
            textInputType: TextInputType.phone,
            validator: (value) {
              final phone = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
              if (phone.length < 12) {
                return 'Введите корректный номер';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            titleColor: theme.colorScheme.onSurface,
            filledColor: theme.colorScheme.surface,
            controller: commentController,
            hintText: l10n.comment,
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            filledColor: theme.colorScheme.surface,
            controller: timeController,
            isReadOnly: true,
            onTap: () => onTimeSelect(context),
            hintText: l10n.chooseTime,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Выберите время';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          PaymentTypeSelector(
            currentPaymentType: currentPaymentType,
            onChanged: onPaymentTypeChanged,
          ),
          const SizedBox(height: 16),
          Text(l10n.orderPickupAd, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
          Text(l10n.address, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
          const SizedBox(height: 10),
          SubmitButtonWidget(
            title: l10n.confirmOrder,
            bgColor: Theme.of(context).colorScheme.primary,
            textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
            onTap: onConfirmTap,
          ),
        ],
      ),
    );
  }
}
