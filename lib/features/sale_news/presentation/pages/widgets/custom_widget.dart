import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? image;
  final String placeholderImage;
  final int? discount;

  const CardWidget({
    super.key,
    required this.title,
    required this.description,
    this.image,
    this.placeholderImage = 'assets/images/app_icon.png',
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageWidget(
            image: image,
            placeholderImage: placeholderImage,
          ),
          TextContentWidget(
            title: title,
            description: description,
            discount: discount,
          ),
        ],
      ),
    );
  }
}
