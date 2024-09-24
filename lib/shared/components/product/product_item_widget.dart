import 'package:dio/dio.dart';
import 'package:diyar/features/menu/data/datasources/menu_remote_data_sources.dart';
import 'package:diyar/features/menu/data/models/food_model.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/shared/components/product/product_bottom_widget.dart';
import 'package:diyar/shared/components/product/product_item_content_widget.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductItemWidget extends StatelessWidget {
  final FoodModel food;
  final int quantity;

  const ProductItemWidget(
      {super.key, required this.food, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final dio = sl<Dio>();
    return ProductItemContentWidget(
      food: food,
      quantity: quantity,
      onTap: () => AppBottomSheet.showBottomSheet(
        context,
        initialChildSize: 0.6,
        ProductBottomWidget(
          onTap: () {},
          dataSource: MenuRemoteDataSourceImpl(dio, prefs),
          isShadowVisible: false,
          food: food,
          quantity: quantity,
          isCounter: false,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
