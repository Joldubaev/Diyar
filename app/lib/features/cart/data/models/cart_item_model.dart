import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/menu/menu.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_model.freezed.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    FoodModel? food,
    FoodModel? garnish,
    int? quantity,
    double? totalPrice,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Используем кастомный fromJson для поддержки fallback на 'totalPrice'
    return CartItemModel(
      food: json['food'] == null ? null : FoodModel.fromJson(json['food'] as Map<String, dynamic>),
      // Старые записи корзины (до появления гарниров) поля не имеют — null.
      garnish: json['garnish'] == null ? null : FoodModel.fromJson(json['garnish'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt(),
      // Используем ключ 'price' для обратной совместимости с Hive и API
      // Fallback на 'totalPrice' для обратной совместимости
      totalPrice: (json['price'] as num?)?.toDouble() ?? (json['totalPrice'] as num?)?.toDouble(),
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) => CartItemModel(
        food: entity.food != null ? FoodModel.fromEntity(entity.food!) : null,
        garnish: entity.garnish != null ? FoodModel.fromEntity(entity.garnish!) : null,
        quantity: entity.quantity,
        totalPrice: entity.totalPrice,
      );
}

extension CartItemModelX on CartItemModel {
  CartItemEntity toEntity() => CartItemEntity(
        food: food?.toEntity(),
        garnish: garnish?.toEntity(),
        quantity: quantity,
        totalPrice: totalPrice,
      );

  /// Ключ позиции в Hive: блюдо + гарнир (см. [CartItemEntity.rowKey]).
  String? get rowKey {
    final foodId = food?.id;
    if (foodId == null) return null;
    final garnishId = garnish?.id;
    return garnishId == null ? foodId : '$foodId::$garnishId';
  }

  /// Кастомный toJson для обратной совместимости с ключом 'price'
  /// Переопределяем стандартный toJson freezed для использования 'price' вместо 'totalPrice'
  Map<String, dynamic> toJsonCustom() => {
        'food': food?.toJson(),
        if (garnish != null) 'garnish': garnish?.toJson(),
        'quantity': quantity,
        'price': totalPrice, // Используем 'price' вместо 'totalPrice' для совместимости
      };
}
