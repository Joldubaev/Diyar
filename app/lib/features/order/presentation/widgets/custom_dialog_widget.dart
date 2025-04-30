import 'package:flutter/material.dart';

class CustomDialogWidgets extends StatelessWidget {
  const CustomDialogWidgets({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(description),
      ],
    );
  }
}
