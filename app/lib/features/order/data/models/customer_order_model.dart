import 'package:diyar/features/features.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_order_model.freezed.dart';
part 'customer_order_model.g.dart';

@freezed
class CustomerOrderModel with _$CustomerOrderModel {
  const factory CustomerOrderModel({
    String? id,
    List<FoodModel>? foods,
    String? address,
    String? status,
  }) = _CustomerOrderModel;

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerOrderModelFromJson(json);

  factory CustomerOrderModel.fromEntity(CustomerOrderEntity entity) =>
      CustomerOrderModel(
        id: entity.id,
        foods: entity.foods?.map((foodEntity) => FoodModel.fromEntity(foodEntity)).toList(),
        address: entity.address,
        status: entity.status,
      );
}

extension CustomerOrderModelX on CustomerOrderModel {
  CustomerOrderEntity toEntity() => CustomerOrderEntity(
        id: id,
        foods: foods?.map((foodModel) => foodModel.toEntity()).toList(),
        address: address,
        status: status,
      );
}
