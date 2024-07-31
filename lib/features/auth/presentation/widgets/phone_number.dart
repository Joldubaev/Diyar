import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneNumberMask extends StatefulWidget {
  const PhoneNumberMask({
    Key? key,
    required this.hint,
    required this.textInputType,
    required this.textController,
    required this.hintText,
    required this.formatter,
    this.isReadOnly,
    this.validator,
    this.title,
  }) : super(key: key);
  final TextEditingController textController;
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;
  final String hint;
  final String? title;
  final String hintText;
  final TextInputType textInputType;
  final bool? isReadOnly;
  @override
  PhoneNumberMaskState createState() => PhoneNumberMaskState();
}

class PhoneNumberMaskState extends State<PhoneNumberMask> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (widget.title != null) const SizedBox(height: 6),
        TextFormField(
          readOnly: widget.isReadOnly ?? false,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          controller: widget.textController,
          inputFormatters: [const UpperCaseTextFormatter(), widget.formatter],
          autocorrect: false,
          keyboardType: widget.textInputType,
          autovalidateMode: AutovalidateMode.disabled,
          validator: widget.validator,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: AppColors.grey,
                  width: 0.1,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              filled: true,
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.red),
              ),
              errorMaxLines: 1),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter implements TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

class SpecialMaskTextInputFormatter extends MaskTextInputFormatter {
  static String maskA = "S.####";
  static String maskB = "S.######";

  SpecialMaskTextInputFormatter({String? initialText})
      : super(
            mask: maskA,
            filter: {"#": RegExp('[0-9]'), "S": RegExp('[AB]')},
            initialText: initialText);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith("A")) {
      if (getMask() != maskA) {
        updateMask(mask: maskA);
      }
    } else {
      if (getMask() != maskB) {
        updateMask(mask: maskB);
      }
    }
    return super.formatEditUpdate(oldValue, newValue);
  }
}
