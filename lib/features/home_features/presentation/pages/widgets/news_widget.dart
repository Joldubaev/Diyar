import 'package:cached_network_image/cached_network_image.dart';
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
          Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/images/app_logo.png",
                  fit: BoxFit.cover,
                  color: Colors.orange,
                ),
                fit: BoxFit.cover,
                height: 150,
                memCacheHeight: 150,
              ),
            ),
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
