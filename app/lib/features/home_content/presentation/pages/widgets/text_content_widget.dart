
import 'package:flutter/material.dart';

class TextContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final int? discount;

  const TextContentWidget({
    super.key,
    required this.title,
    required this.description,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title${discount != null ? ' - $discount%' : ''}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
