import 'package:diyar/core/components/components.dart';
import 'package:diyar/features/order/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_model.freezed.dart';
part 'create_order_model.g.dart';

@freezed
class CreateOrderModel with _$CreateOrderModel {
  const factory CreateOrderModel({
    String? address,
    String? comment,
    int? dishesCount,
    String? entrance,
    String? floor,
    List<FoodItemOrderModel>? foods,
    String? houseNumber,
    String? intercom,
    String? kvOffice,
    String? paymentMethod,
    int? price,
    String? userName,
    String? userPhone,
    int? deliveryPrice,
    int? sdacha,
    String? region,
  }) = _CreateOrderModel;

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderModelFromJson(json);

  factory CreateOrderModel.fromEntity(CreateOrderEntity entity) =>
      CreateOrderModel(
        address: entity.address,
        comment: entity.comment,
        dishesCount: entity.dishesCount,
        entrance: entity.entrance,
        floor: entity.floor,
        foods: entity.foods.map((food) => FoodItemOrderModel.fromEntity(food)).toList(),
        houseNumber: entity.houseNumber,
        intercom: entity.intercom,
        kvOffice: entity.kvOffice,
        paymentMethod: entity.paymentMethod,
        price: entity.price,
        userName: entity.userName,
        userPhone: entity.userPhone,
        deliveryPrice: entity.deliveryPrice,
        sdacha: entity.sdacha,
        region: entity.region,
      );
}

extension CreateOrderModelX on CreateOrderModel {
  CreateOrderEntity toEntity() => CreateOrderEntity(
        address: address ?? '',
        comment: comment,
        dishesCount: dishesCount ?? 0,
        entrance: entrance,
        floor: floor,
        foods: foods?.map((food) => food.toEntity()).toList() ?? [],
        houseNumber: houseNumber ?? '',
        intercom: intercom,
        kvOffice: kvOffice,
        paymentMethod: paymentMethod ?? '',
        price: price ?? 0,
        userName: userName ?? '',
        userPhone: userPhone ?? '',
        deliveryPrice: deliveryPrice ?? 0,
        sdacha: sdacha,
        region: region,
      );
}
