import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'product_item_content_widget.dart';
import 'package:flutter/material.dart';

class ProductItemWidget extends StatelessWidget {
  final FoodEntity food;
  final int quantity;

  const ProductItemWidget({
    super.key,
    required this.food,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return ProductItemContentWidget(
      food: food,
      quantity: quantity,
      onTap: () => context.pushRoute(
        ProductDetailRoute(
          food: food,
          quantity: quantity,
        ),
      ),
    );
  }
}
