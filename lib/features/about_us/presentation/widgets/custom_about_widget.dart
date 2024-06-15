import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/about_us/data/models/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAboutWidget extends StatelessWidget {
  final AboutUsModel model;

  const CustomAboutWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    log('photoLinks: ${model.photoLinks!.length}');
    log('photoLinks: ${model.photoLinks!.first}');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.name.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              model.description.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (model.photoLinks == null || model.photoLinks!.isEmpty)
              Center(
                child: SvgPicture.asset('assets/icons/boxes.svg', height: 200),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: model.photoLinks!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: model.photoLinks![index],
                          fit: BoxFit.cover,
                          memCacheHeight: 300,
                          memCacheWidth: 300,
                          errorWidget: (context, url, error) =>
                              SvgPicture.asset('assets/icons/boxes.svg',
                                  height: 50),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
