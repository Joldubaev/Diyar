import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class TextButtonLogin extends StatelessWidget {
  const TextButtonLogin({
    super.key,
    required this.title,
    required this.traling,
    required this.onPressed,
  });
  final String title;
  final String traling;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: Text(
            title,
            style: theme.textTheme.headlineLarge,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: FittedBox(
            child: Text(
              traling,
              style: theme.textTheme.headlineLarge!.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
