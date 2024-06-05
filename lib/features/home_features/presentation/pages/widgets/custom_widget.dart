import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? image;
  final String placeholderImage;
  final int? discount;

  const CardWidget({
    Key? key,
    required this.title,
    required this.description,
    this.image,
    this.placeholderImage = 'assets/images/app_icon.png',
    this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageWidget(context),
          _buildTextContent(),
        ],
      ),
    );
  }

  Widget _buildImageWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: Image.asset(
            placeholderImage,
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          ),
        ),
        if (image != null && image!.isNotEmpty)
          Image.network(
            image!,
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const CircularProgressIndicator();
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                placeholderImage,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              );
            },
          ),
      ],
    );
  }

  Widget _buildTextContent() {
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
