import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PickupPhoneField extends StatelessWidget {
  const PickupPhoneField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return PhoneNumberMask(
      hintText: hintText,
      textController: controller,
      hint: context.l10n.phone,
      formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
      textInputType: TextInputType.phone,
      validator: (value) {
        final phone = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
        if (phone.length < 12) {
          return 'Введите корректный номер';
        }
        return null;
      },
    );
  }
}
