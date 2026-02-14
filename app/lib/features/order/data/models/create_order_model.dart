import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/order/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_model.freezed.dart';
part 'create_order_model.g.dart';

@freezed
class CreateOrderModel with _$CreateOrderModel {
  const CreateOrderModel._(); // Нужно для методов

  const factory CreateOrderModel({
    required AddressModel addressData,
    required ContactInfoModel contactInfo,
    required List<FoodItemOrderModel> foods,
    required int dishesCount,
    required String paymentMethod,
    required int price,
    required int deliveryPrice,
    int? sdacha,
    double? amountToReduce,
  }) = _CreateOrderModel;

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) => _$CreateOrderModelFromJson(json);

  factory CreateOrderModel.fromEntity(CreateOrderEntity entity) => CreateOrderModel(
        addressData: AddressModel.fromEntity(entity.addressData),
        contactInfo: ContactInfoModel.fromEntity(entity.contactInfo),
        dishesCount: entity.dishesCount,
        foods: entity.foods.map((food) => FoodItemOrderModel.fromEntity(food)).toList(),
        paymentMethod: entity.paymentMethod,
        price: entity.price,
        deliveryPrice: entity.deliveryPrice,
        sdacha: entity.sdacha,
        amountToReduce: entity.amountToReduce,
      );
}

/// Выносим логику формирования JSON для API в расширение-маппер
/// Это позволяет API менять структуру, не меняя нашу модель данных
extension CreateOrderApiExtension on CreateOrderModel {
  Map<String, dynamic> toApiJson() {
    return {
      'address': addressData.address,
      'houseNumber': addressData.houseNumber,
      'comment': addressData.comment,
      'entrance': addressData.entrance,
      'floor': addressData.floor,
      'intercom': addressData.intercom,
      'kvOffice': addressData.kvOffice,
      'region': addressData.region,
      'userName': contactInfo.userName,
      'userPhone': contactInfo.userPhone,
      'dishesCount': dishesCount,
      'foods': foods.map((e) => e.toJson()).toList(),
      'paymentMethod': paymentMethod,
      'price': price,
      'deliveryPrice': deliveryPrice,
      'sdacha': sdacha,
      if (amountToReduce != null && amountToReduce! > 0) 'amountToReduce': amountToReduce,
    };
  }
}
