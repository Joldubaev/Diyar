import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? image;
  final String placeholderImage;

  const ImageWidget({
    Key? key,
    this.image,
    required this.placeholderImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}