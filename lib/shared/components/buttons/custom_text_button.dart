import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.textButton,
    this.onPressed,
    this.time,
    this.description,
  });

  final String textButton;
  final String? description;
  final DateTime? time;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            textButton,
            style:
                theme.textTheme.bodySmall!.copyWith(color: AppColors.primary),
            maxLines: 2,
            textAlign: TextAlign.center,
          )),
    );
  }
}
