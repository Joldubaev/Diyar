import 'package:diyar/core/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.textButton,
    this.onPressed,
    this.time,
    this.description,
    this.textStyle,
  });

  final String textButton;
  final String? description;
  final DateTime? time;
  final Function()? onPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            textButton,
            style: textStyle ??
                Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
            maxLines: 2,
            textAlign: TextAlign.center,
          )),
    );
  }
}
