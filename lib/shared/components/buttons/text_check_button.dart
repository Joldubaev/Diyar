import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class TextCheckButton extends StatelessWidget {
  const TextCheckButton({
    super.key,
    required this.text,
    required this.route,
    this.onPressed,
  });
  final String text;
  final String route;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style:
                theme.textTheme.bodyMedium!.copyWith(color: AppColors.black1)),
        TextButton(
          onPressed: onPressed,
          child: FittedBox(
            child: Text(
              route,
              style: theme.textTheme.bodyLarge!.copyWith(color: AppColors.blue),
            ),
          ),
        )
      ],
    );
  }
}
