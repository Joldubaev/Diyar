import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class PickupUserNameField extends StatelessWidget {
  const PickupUserNameField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return CustomInputWidget(
      titleColor: context.colorScheme.onSurface,
      filledColor: context.colorScheme.surface,
      controller: controller,
      hintText: hintText,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Введите имя';
        }
        return null;
      },
    );
  }
}
