import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? image;
  final String placeholderImage;

  const ImageWidget({
    super.key,
    this.image,
    required this.placeholderImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: (image != null && image!.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: image!,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
              memCacheWidth: 400,
              memCacheHeight: 300,
              placeholder: (_, __) => Image.asset(
                placeholderImage,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
              errorWidget: (_, __, ___) => Image.asset(
                placeholderImage,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            )
          : Image.asset(
              placeholderImage,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
    );
  }
}
