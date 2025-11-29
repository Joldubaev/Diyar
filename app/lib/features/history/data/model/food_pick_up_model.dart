import 'package:diyar/features/history/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_pick_up_model.freezed.dart';
part 'food_pick_up_model.g.dart';

@freezed
class FoodPickupModel with _$FoodPickupModel {
  const factory FoodPickupModel({
    int? quantity,
    String? name,
    int? price,
  }) = _FoodPickupModel;

  factory FoodPickupModel.fromJson(Map<String, dynamic> json) =>
      _$FoodPickupModelFromJson(json);

  factory FoodPickupModel.fromEntity(FoodPickUpEntity entity) =>
      FoodPickupModel(
        quantity: entity.quantity,
        name: entity.name,
        price: entity.price,
      );
}

extension FoodPickupModelX on FoodPickupModel {
  FoodPickUpEntity toEntity() => FoodPickUpEntity(
        quantity: quantity,
        name: name,
        price: price,
      );
}
