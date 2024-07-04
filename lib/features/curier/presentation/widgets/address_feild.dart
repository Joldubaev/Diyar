import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  const AddressField({this.value, this.child, super.key});

  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8)),
        child: child ??
            Center(
              child: Text(
                value ?? '',
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
            ),
      ),
    );
  }
}
