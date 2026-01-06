import 'package:diyar/core/components/input/phone_number.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Поля контактной информации формы доставки
class DeliveryFormContactFields extends StatelessWidget {
  final ThemeData theme;
  final TextEditingController userName;
  final TextEditingController phoneController;

  const DeliveryFormContactFields({
    super.key,
    required this.theme,
    required this.userName,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputWidget(
          titleColor: theme.colorScheme.onSurface,
          filledColor: theme.colorScheme.surface,
          controller: userName,
          hintText: context.l10n.yourName,
          validator: (value) {
            if (value!.isEmpty) {
              return context.l10n.pleaseEnterName;
            } else if (value.length < 3) {
              return context.l10n.pleaseEnterCorrectName;
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        PhoneNumberMask(
          hintText: '+996 (___) __-__-__',
          textController: phoneController,
          hint: context.l10n.phone,
          formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
          textInputType: TextInputType.phone,
          validator: (value) {
            if (value!.isEmpty) {
              return context.l10n.pleaseEnterPhone;
            } else if (value.length < 10) {
              return context.l10n.pleaseEnterCorrectPhone;
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

