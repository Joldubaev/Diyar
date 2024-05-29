import 'package:flutter/material.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    required this.onPressed,
    super.key,
    required this.title,
  });

  final void Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
