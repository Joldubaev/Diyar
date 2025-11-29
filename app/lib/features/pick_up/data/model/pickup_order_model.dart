import 'package:diyar/core/core.dart';
import 'package:diyar/features/pick_up/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pickup_order_model.freezed.dart';
part 'pickup_order_model.g.dart';

@freezed
class PickupOrderModel with _$PickupOrderModel {
  const factory PickupOrderModel({
    int? dishesCount,
    List<FoodItemOrderModel>? foods,
    String? prepareFor,
    int? price,
    String? userName,
    String? userPhone,
    String? comment,
    String? paymentMethod,
  }) = _PickupOrderModel;

  factory PickupOrderModel.fromJson(Map<String, dynamic> json) => _$PickupOrderModelFromJson(json);

  factory PickupOrderModel.fromEntity(PickupOrderEntity entity) => PickupOrderModel(
        dishesCount: entity.dishesCount,
        foods: entity.foods.map((foodEntity) => FoodItemOrderModel.fromEntity(foodEntity)).toList(),
        prepareFor: entity.prepareFor,
        price: entity.price,
        userName: entity.userName,
        userPhone: entity.userPhone,
        comment: entity.comment,
        paymentMethod: entity.paymentMethod,
      );
}

extension PickupOrderModelX on PickupOrderModel {
  PickupOrderEntity toEntity() => PickupOrderEntity(
        dishesCount: dishesCount ?? 0,
        foods: foods?.map((foodModel) => foodModel.toEntity()).toList() ?? [],
        prepareFor: prepareFor ?? '',
        price: price ?? 0,
        userName: userName ?? '',
        userPhone: userPhone ?? '',
        comment: comment,
        paymentMethod: paymentMethod,
      );
}
