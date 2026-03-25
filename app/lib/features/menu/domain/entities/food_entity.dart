import 'allergen_entity.dart';
import 'ingredient_entity.dart';

class FoodEntity {
  final String? id;
  final String? name;
  final String? description;
  final String? categoryId;
  final int? price;
  final String? weight;
  final String? urlPhoto;
  final bool? stopList;
  final int? iDctMax;
  final String? containerName;
  final int? containerCount;
  final int? quantity;
  final int? containerPrice;
  final List<IngredientEntity>? ingredients;
  final List<AllergenEntity>? allergens;

  FoodEntity({
    this.id,
    this.name,
    this.description,
    this.categoryId,
    this.price,
    this.weight,
    this.urlPhoto,
    this.stopList,
    this.iDctMax,
    this.containerName,
    this.containerCount,
    this.quantity,
    this.containerPrice,
    this.ingredients,
    this.allergens,
  });

  FoodEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    int? price,
    String? weight,
    String? urlPhoto,
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