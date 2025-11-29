import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/menu/menu.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    FoodModel? food,
    int? quantity,
    double? totalPrice,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);

  factory CartItemModel.fromEntity(CartItemEntity entity) => CartItemModel(
        food: entity.food != null ? FoodModel.fromEntity(entity.food!) : null,
        quantity: entity.quantity,
        totalPrice: entity.totalPrice,
      );
}

extension CartItemModelX on CartItemModel {
  CartItemEntity toEntity() => CartItemEntity(
        food: food?.toEntity(),
        quantity: quantity,
        totalPrice: totalPrice,
      );
}
