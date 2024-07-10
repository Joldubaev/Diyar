import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/cart/presentation/presentation.dart';
import 'package:diyar/features/menu/data/data.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/fmt/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CartItemWidgets extends StatelessWidget {
  final FoodModel food;
  final int counter;
  final void Function() onRemove;
  const CartItemWidgets({
    super.key,
    required this.food,
    required this.counter,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CachedNetworkImage(
                      fadeInCurve: Curves.easeIn,
                      fadeOutCurve: Curves.easeOut,
                      imageUrl: food.urlPhoto ?? '',
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/placeholder.png'),
                      width: 120,
                      height: 120,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${food.name}",
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            AppAlert.showConfirmDialog(
                                context: context,
                                title: context.l10n.deleteOrder,
                                content: Text(context.l10n.deleteOrderText),
                                confirmPressed: onRemove);
                          },
                          icon: SvgPicture.asset('assets/icons/delete.svg'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: "${food.weight}",
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: AppColors.grey),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${food.price} сом',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: AppColors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CounterWidget(counter: counter, id: food.id ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
