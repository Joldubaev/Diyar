import 'package:diyar/shared/components/product/product_item_content_widget.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductItemWidget extends StatefulWidget {
  final FoodModel food;
  final int quantity;
  const ProductItemWidget(
      {super.key, required this.food, required this.quantity});

  @override
  ProductItemWidgetState createState() => ProductItemWidgetState();
}

class ProductItemWidgetState extends State<ProductItemWidget> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      _currentQuantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProductItemContentWidget(
      food: widget.food,
      quantity: _currentQuantity,
      onTap: () {
        AppBottomSheet.showBottomSheet(
          context,
          initialChildSize: 0.4,
          StatefulBuilder(
            builder: (BuildContext context, setState) {
              return ProductItemContentWidget(
                food: widget.food,
                quantity: _currentQuantity,
                isCounter: true,
                onQuantityChanged: (newQuantity) {
                  _updateQuantity(newQuantity);
                  setState(() {});
                },
              );
            },
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
