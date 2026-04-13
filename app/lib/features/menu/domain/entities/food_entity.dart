import 'package:equatable/equatable.dart';

import 'allergen_entity.dart';
import 'ingredient_entity.dart';

class FoodEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? categoryId;
  final int? price;
  final String? weight;
  final String? urlPhoto;
  final String? urlPhotoThumb;
  final bool? stopList;
  final int? iDctMax;
  final String? containerName;
  final int? containerCount;
  final int? quantity;
  final int? containerPrice;
  final List<IngredientEntity>? ingredients;
  final List<AllergenEntity>? allergens;

  const FoodEntity({
    this.id,
    this.name,
    this.description,
    this.categoryId,
    this.price,
    this.weight,
    this.urlPhoto,
    this.urlPhotoThumb,
    this.stopList,
    this.iDctMax,
    this.containerName,
    this.containerCount,
    this.quantity,
    this.containerPrice,
    this.ingredients,
    this.allergens,
  });

  /// Список меню, корзина, миниатюра: thumb, иначе полное фото.
  String? get imageUrlForList {
    final t = urlPhotoThumb;
    if (t != null && t.isNotEmpty) return t;
    return urlPhoto;
  }

  /// Деталь / полный экран: полное фото, иначе thumb.
  String? get imageUrlForDetail {
    final f = urlPhoto;
    if (f != null && f.isNotEmpty) return f;
    return urlPhotoThumb;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categoryId,
        price,
        weight,
        urlPhoto,
        urlPhotoThumb,
        stopList,
        iDctMax,
        containerName,
        containerCount,
        quantity,
        containerPrice,
        ingredients,
        allergens,
      ];

  FoodEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    int? price,
    String? weight,
    String? urlPhoto,
    String? urlPhotoThumb,
    bool? stopList,
    int? iDctMax,
    String? containerName,
    int? containerCount,
    int? quantity,
    int? containerPrice,
    List<IngredientEntity>? ingredients,
    List<AllergenEntity>? allergens,
  }) =>
      FoodEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        price: price ?? this.price,
        weight: weight ?? this.weight,
        urlPhoto: urlPhoto ?? this.urlPhoto,
        urlPhotoThumb: urlPhotoThumb ?? this.urlPhotoThumb,
        stopList: stopList ?? this.stopList,
        iDctMax: iDctMax ?? this.iDctMax,
        containerName: containerName ?? this.containerName,
        containerCount: containerCount ?? this.containerCount,
        quantity: quantity ?? this.quantity,
        containerPrice: containerPrice ?? this.containerPrice,
        ingredients: ingredients ?? this.ingredients,
        allergens: allergens ?? this.allergens,
      );
}