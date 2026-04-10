import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../theme/app_colors.dart';

class PhoneNumberInput extends StatelessWidget {
  PhoneNumberInput({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.hint = '+996 (___) __ __ __',
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String hint;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;

  final _formatter = MaskTextInputFormatter(
    mask: '+996 (###) ## ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        _formatter,
        LengthLimitingTextInputFormatter(19),
      ],
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
