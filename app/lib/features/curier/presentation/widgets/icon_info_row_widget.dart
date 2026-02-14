import 'package:diyar/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';

class IconInfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const IconInfoRowWidget({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.theme.hintColor),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyMedium,
            children: [
              TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: value.isNotEmpty ? value : '—'),
            ],
          ),
        ),
      ],
    );
  }
}