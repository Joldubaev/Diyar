import 'package:diyar/features/curier/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'curier_food_model.dart';

part 'curier_model.freezed.dart';
part 'curier_model.g.dart';

@freezed
class CurierOrderModel with _$CurierOrderModel {
  const factory CurierOrderModel({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    int? orderNumber,
    int? dishesCount,
    List<CurierFoodModel>? foods,
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
  }) = _CurierOrderModel;

  factory CurierOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CurierOrderModelFromJson(json);

  factory CurierOrderModel.fromEntity(CurierEntity entity) =>
      CurierOrderModel(
        id: entity.id,
        userId: entity.userId,
        userName: entity.userName,
        userPhone: entity.userPhone,
        orderNumber: entity.orderNumber,
        dishesCount: entity.dishesCount,
        foods: entity.foods?.map((x) => CurierFoodModel.fromEntity(x)).toList(),
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
      );
}

extension CurierOrderModelX on CurierOrderModel {
  CurierEntity toEntity() => CurierEntity(
        id: id,
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        orderNumber: orderNumber,
        dishesCount: dishesCount,
        foods: foods?.map((x) => x.toEntity()).toList(),
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
      );
}
