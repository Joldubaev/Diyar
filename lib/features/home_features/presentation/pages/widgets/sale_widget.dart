import 'package:flutter/material.dart';

class SaleWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int discount;

  const SaleWidget({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Image.network(image),
          const SizedBox(height: 8),
          Text(
            ' $title $discount%',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(description),
        ],
      ),
    );
  }
}
