import 'package:equatable/equatable.dart';

import 'package:diyar/features/menu/domain/domain.dart';

class CartItemEntity extends Equatable {
  final FoodEntity? food;

  /// Гарнир, выбранный к блюду ([FoodEntity.requiresGarnish]).
  /// Хранится внутри позиции: количество гарнира всегда равно количеству
  /// блюда, а удаление блюда убирает и его гарнир.
  final FoodEntity? garnish;
  final int? quantity;
  final double? totalPrice;

  const CartItemEntity({
    this.food,
    this.garnish,
    this.quantity,
    this.totalPrice,
  });

  /// Уникальный ключ позиции корзины: одно блюдо с разными гарнирами —
  /// разные позиции.
  String? get rowKey {
    final foodId = food?.id;
    if (foodId == null) return null;
    final garnishId = garnish?.id;
    return garnishId == null ? foodId : '$foodId::$garnishId';
  }

  /// Цена одной единицы позиции: блюдо + гарнир.
  double get unitPrice => (food?.price?.toDouble() ?? 0) + (garnish?.price?.toDouble() ?? 0);

  @override
  List<Object?> get props => [food, garnish, quantity, totalPrice];

  CartItemEntity copyWith({
    FoodEntity? food,
    FoodEntity? garnish,
    int? quantity,
    double? totalPrice,
  }) {
    return CartItemEntity(
      food: food ?? this.food,
      garnish: garnish ?? this.garnish,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

extension CartItemsListX on List<CartItemEntity> {
  /// Разворачивает позиции с гарнирами в плоский список для бэкенда:
  /// гарнир становится отдельной позицией с тем же количеством, одинаковые
  /// блюда/гарниры сливаются. Формат заказа не меняется — сервер, как и
  /// раньше, получает блюда и гарниры отдельными строками.
  List<CartItemEntity> expandGarnishes() {
    final byKey = <String, CartItemEntity>{};

    void put(FoodEntity? food, int quantity) {
      final id = food?.id;
      if (id == null || quantity <= 0) return;
      final existing = byKey[id];
      byKey[id] = existing == null
          ? CartItemEntity(food: food, quantity: quantity)
          : existing.copyWith(quantity: (existing.quantity ?? 0) + quantity);
    }

    for (final item in this) {
      final quantity = item.quantity ?? 0;
      put(item.food, quantity);
      put(item.garnish, quantity);
    }
    return byKey.values.toList();
  }
}
