import 'package:diyar/features/menu/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_model.freezed.dart';
part 'food_model.g.dart';

@freezed
class FoodModel with _$FoodModel {
  const factory FoodModel({
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
    num? containerPrice,
  }) = _FoodModel;

  factory FoodModel.fromJson(Map<String, dynamic> json) => _$FoodModelFromJson(json);

  factory FoodModel.fromEntity(FoodEntity entity) => FoodModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        categoryId: entity.categoryId,
        price: entity.price,
        weight: entity.weight,
        urlPhoto: entity.urlPhoto,
        stopList: entity.stopList,
        iDctMax: entity.iDctMax,
        containerName: entity.containerName,
        containerCount: entity.containerCount,
        quantity: entity.quantity,
        containerPrice: entity.containerPrice,
      );
}

extension FoodModelX on FoodModel {
  FoodEntity toEntity() => FoodEntity(
        id: id,
        name: name,
        description: description,
        categoryId: categoryId,
        price: price,
        weight: weight,
        urlPhoto: urlPhoto,
        stopList: stopList,
        iDctMax: iDctMax,
        containerName: containerName,
        containerCount: containerCount,
        quantity: quantity,
        containerPrice: containerPrice?.toInt(),
      );
}
