import 'package:flutter/material.dart';

class InfoDialogWidget extends StatelessWidget {
  const InfoDialogWidget({
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
