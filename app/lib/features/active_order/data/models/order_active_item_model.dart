import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:diyar/features/menu/menu.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_active_item_model.freezed.dart';
part 'order_active_item_model.g.dart';

@freezed
class OrderActiveItemModel with _$OrderActiveItemModel {
  const factory OrderActiveItemModel({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    int? orderNumber,
    int? dishesCount,
    List<FoodModel>? foods,
    String? address,
    String? houseNumber,
    String? kvOffice,
    String? intercom,
    String? floor,
    String? entrance,
    String? comment,
    String? paymentMethod,
    int? price,
    String? timeRequest,
    String? courierId,
    String? status,
    int? deliveryPrice,
    int? sdacha,
    int? amountToReduce,
  }) = _OrderActiveItemModel;

  factory OrderActiveItemModel.fromJson(Map<String, dynamic> json) => _$OrderActiveItemModelFromJson(json);

  factory OrderActiveItemModel.fromEntity(OrderActiveItemEntity entity) => OrderActiveItemModel(
        id: entity.id,
        userId: entity.userId,
        userName: entity.userName,
        userPhone: entity.userPhone,
        orderNumber: entity.orderNumber,
        dishesCount: entity.dishesCount,
        foods: entity.foods?.map((e) => FoodModel.fromEntity(e)).toList(),
        address: entity.address,
        houseNumber: entity.houseNumber,
        kvOffice: entity.kvOffice,
        intercom: entity.intercom,
        floor: entity.floor,
        entrance: entity.entrance,
        comment: entity.comment,
        paymentMethod: entity.paymentMethod,
        price: entity.price,
        timeRequest: entity.timeRequest,
        courierId: entity.courierId,
        status: entity.status,
        deliveryPrice: entity.deliveryPrice,
        sdacha: entity.sdacha,
        amountToReduce: entity.amountToReduce,
      );
}

extension OrderActiveItemModelX on OrderActiveItemModel {
  OrderActiveItemEntity toEntity() => OrderActiveItemEntity(
        id: id,
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        orderNumber: orderNumber,
        dishesCount: dishesCount,
        foods: foods?.map((e) => e.toEntity()).toList(),
        address: address,
        houseNumber: houseNumber,
        kvOffice: kvOffice,
        intercom: intercom,
        floor: floor,
        entrance: entrance,
        comment: comment,
        paymentMethod: paymentMethod,
        price: price,
        timeRequest: timeRequest,
        courierId: courierId,
        status: status,
        deliveryPrice: deliveryPrice,
        sdacha: sdacha,
        amountToReduce: amountToReduce,
      );
}
