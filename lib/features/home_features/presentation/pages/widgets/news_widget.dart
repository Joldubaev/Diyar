import 'package:flutter/material.dart';

class NewsWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const NewsWidget({
    required this.title,
    required this.description,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          const SizedBox(height: 8),
          Text(
            title,
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
