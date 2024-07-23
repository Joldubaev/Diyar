import 'package:diyar/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/features.dart';

class ProductBottomWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool? isCounter;
  final bool? isShadowVisible;
  final int quantity;
  final FoodModel food;

  const ProductBottomWidget({
    Key? key,
    this.onTap,
    this.isShadowVisible = true,
    required this.food,
    required this.quantity,
    this.isCounter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isShadowVisible!
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl:
                    food.urlPhoto ?? 'https://i.ibb.co/GkL25DB/ALE-1357-7.png',
                errorWidget: (context, url, error) => Image.asset(
                    'assets/images/app_logo.png',
                    color: theme.colorScheme.onSurface.withOpacity(0.1)),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                memCacheWidth: 710,
                memCacheHeight: 710,
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
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                  child: Text('${food.name}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2)),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: '${food.weight}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: theme.colorScheme.onSurface),
                    children: [
                      TextSpan(
                          text: ' - ${food.price} сом',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
