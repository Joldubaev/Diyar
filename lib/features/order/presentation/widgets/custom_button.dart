import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.title,
    required this.bgColor,
  });

  final void Function()? onTap;
  final String title;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: FittedBox(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium!.copyWith(color: bgColor),
          ),
        ),
      ),
    );
  }
}