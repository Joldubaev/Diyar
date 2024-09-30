import 'package:diyar/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/features.dart';

class ProductBottomWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final bool? isCounter;
  final bool? isShadowVisible;
  final int quantity;
  final FoodModel food;
  final MenuRemoteDataSource dataSource;

  const ProductBottomWidget({
    Key? key,
    this.onTap,
    this.isShadowVisible = true,
    required this.food,
    required this.quantity,
    this.isCounter = true,
    required this.dataSource,
  }) : super(key: key);

  @override
  ProductBottomWidgetState createState() => ProductBottomWidgetState();
}

class ProductBottomWidgetState extends State<ProductBottomWidget> {
  // Future<int?>? _imageSizeFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _imageSizeFuture = widget.dataSource.getImageFileSize(
  //       widget.food.urlPhoto ?? 'https://i.ibb.co/GkL25DB/ALE-1357-7.png');
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: widget.isShadowVisible!
            ? [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                )
              ]
            : null,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.food.urlPhoto ??
                    'https://i.ibb.co/GkL25DB/ALE-1357-7.png',
                errorWidget: (context, url, error) => Image.asset(
                    'assets/images/app_logo.png',
                    color: theme.colorScheme.onSurface.withOpacity(0.1)),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                memCacheWidth: 410,
                memCacheHeight: 410,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '${widget.food.name}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text.rich(
                  TextSpan(
                    text: '${widget.food.weight}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: theme.colorScheme.onSurface),
                    children: [
                      TextSpan(
                        text: ' - ${widget.food.price} сом',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.green,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '${widget.food.description}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
              // FutureBuilder<int?>(
              //   future: _imageSizeFuture,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CircularProgressIndicator();
              //     } else if (snapshot.hasData) {
              //       return Text(
              //         'Image size: ${(snapshot.data! / 1024).toStringAsFixed(2)} KB',
              //         style: Theme.of(context).textTheme.bodySmall,
              //       );
              //     } else {
              //       return const Text('Image size unavailable');
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
