import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textColor,
    this.textStyle,
    this.padding = 8.0,
    this.fontSize = 16.0,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? textColor;
  final TextStyle? textStyle;
  final double padding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(padding),
        foregroundColor: textColor ?? Theme.of(context).primaryColor,
        textStyle: textStyle ??
            TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
      ),
      child: Text(label),
    );
  }
}
