import 'package:diyar/core/components/input/phone_number.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Переиспользуемый виджет для полей контакта (имя и телефон)
class ContactFieldsWidget extends StatelessWidget {
  const ContactFieldsWidget({
    super.key,
    required this.theme,
    required this.controllers,
  });

  final ThemeData theme;
  final ContactFormControllers controllers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputWidget(
          titleColor: theme.colorScheme.onSurface,
          filledColor: theme.colorScheme.surface,
          controller: controllers.userName,
          hintText: context.l10n.yourName,
          validator: (value) {
            if (value == null || value.isEmpty) {
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
          textController: controllers.phone,
          hint: context.l10n.phone,
          formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
          textInputType: TextInputType.phone,
          validator: (value) {
            final phone = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
            if (phone.isEmpty) {
              return context.l10n.pleaseEnterPhone;
            } else if (phone.length < 12) {
              return context.l10n.pleaseEnterCorrectPhone;
            }
            return null;
          },
        ),
      ],
    );
  }
}
