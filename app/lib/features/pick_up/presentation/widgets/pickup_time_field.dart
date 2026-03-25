import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

class PickupTimeField extends StatelessWidget {
  const PickupTimeField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomInputWidget(
      filledColor: context.colorScheme.surface,
      controller: controller,
      isReadOnly: true,
      onTap: onTap,
      hintText: hintText,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Выберите время';
        }
        return null;
      },
    );
  }
}
