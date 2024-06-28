import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:diyar/features/about_us/data/models/restaurant_model.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAboutWidget extends StatefulWidget {
  final AboutUsModel model;

  const CustomAboutWidget({super.key, required this.model});

  @override
  CustomAboutWidgetState createState() => CustomAboutWidgetState();
}

class CustomAboutWidgetState extends State<CustomAboutWidget> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.model.photoLinks == null ||
                widget.model.photoLinks!.isEmpty)
              Center(
                child: SvgPicture.asset('assets/icons/boxes.svg', height: 200),
              )
            else
              Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.model.photoLinks!.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: widget.model.photoLinks![index],
                            fit: BoxFit.cover,
                            memCacheHeight: 600,
                            memCacheWidth: 600,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 300,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    carouselController: _controller,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.model.photoLinks!.map((url) {
                      int index = widget.model.photoLinks!.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? const Color.fromRGBO(0, 0, 0, 0.9)
                              : const Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Text(widget.model.name.toString(),
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(
              widget.model.description.toString(),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
