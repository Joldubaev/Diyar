import 'package:diyar/features/menu/menu.dart';
import 'package:diyar/features/order_detail/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_detail_model.freezed.dart';
part 'order_detail_model.g.dart';

@freezed
class OrderDetailModel with _$OrderDetailModel {
  const factory OrderDetailModel({
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
    double? amountToReduce,
  }) = _OrderDetailModel;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => _$OrderDetailModelFromJson(json);

  factory OrderDetailModel.fromEntity(OrderDetailEntity entity) => OrderDetailModel(
        id: entity.id,
        userId: entity.userId,
        userName: entity.userName,
        userPhone: entity.userPhone,
        orderNumber: entity.orderNumber,
        dishesCount: entity.dishesCount,
        foods: entity.foods?.map((e) {
          // Создаем минимальный FoodModel только с нужными полями
          return FoodModel(
            id: null,
            name: e.name,
            description: null,
            categoryId: null,
            price: e.price,
            weight: null,
            urlPhoto: null,
            stopList: null,
            iDctMax: null,
            containerName: null,
            containerCount: null,
            quantity: e.quantity,
            containerPrice: null,
          );
        }).toList(),
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

extension OrderDetailModelX on OrderDetailModel {
  OrderDetailEntity toEntity() => OrderDetailEntity(
        id: id,
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        orderNumber: orderNumber,
        dishesCount: dishesCount,
        foods: foods?.map((e) => OrderDetailFoodItem(
          name: e.name ?? '',
          quantity: e.quantity ?? 0,
          price: e.price,
        )).toList(),
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
