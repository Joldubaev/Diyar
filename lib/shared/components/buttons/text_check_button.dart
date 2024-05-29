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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: onPressed,
          child: FittedBox(child: Text(route)),
        )
      ],
    );
  }
}
