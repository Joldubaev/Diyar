import 'package:diyar/features/curier/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'curier_food_model.freezed.dart';
part 'curier_food_model.g.dart';

@freezed
class CurierFoodModel with _$CurierFoodModel {
  const factory CurierFoodModel({
    int? quantity,
    String? name,
    int? price,
  }) = _CurierFoodModel;

  factory CurierFoodModel.fromJson(Map<String, dynamic> json) => _$CurierFoodModelFromJson(json);

  factory CurierFoodModel.fromEntity(CurierFoodEntity entity) => CurierFoodModel(
        quantity: entity.quantity,
        name: entity.name,
        price: entity.price,
      );
}

extension CurierFoodModelX on CurierFoodModel {
  CurierFoodEntity toEntity() => CurierFoodEntity(
        quantity: quantity,
        name: name,
        price: price,
      );
}
