import 'package:diyar/core/components/components.dart';
import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/order/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_model.freezed.dart';
// part 'create_order_model.g.dar

@freezed
class CreateOrderModel with _$CreateOrderModel {
  const factory CreateOrderModel({
    AddressModel? addressData,
    ContactInfoModel? contactInfo,
    int? dishesCount,
    List<FoodItemOrderModel>? foods,
    String? paymentMethod,
    int? price,
    int? deliveryPrice,
    int? sdacha,
  }) = _CreateOrderModel;

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('addressData') || json.containsKey('contactInfo')) {
      return CreateOrderModel(
        addressData:
            json['addressData'] != null ? AddressModel.fromJson(json['addressData'] as Map<String, dynamic>) : null,
        contactInfo:
            json['contactInfo'] != null ? ContactInfoModel.fromJson(json['contactInfo'] as Map<String, dynamic>) : null,
        dishesCount: (json['dishesCount'] as num?)?.toInt(),
        foods: (json['foods'] as List<dynamic>?)
            ?.map((e) => FoodItemOrderModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        paymentMethod: json['paymentMethod'] as String?,
        price: (json['price'] as num?)?.toInt(),
        deliveryPrice: (json['deliveryPrice'] as num?)?.toInt(),
        sdacha: (json['sdacha'] as num?)?.toInt(),
      );
    }

    return CreateOrderModel(
      addressData: AddressModel(
        address: json['address'] as String? ?? '',
        houseNumber: json['houseNumber'] as String? ?? '',
        comment: json['comment'] as String?,
        entrance: json['entrance'] as String?,
        floor: json['floor'] as String?,
        intercom: json['intercom'] as String?,
        kvOffice: json['kvOffice'] as String?,
        region: json['region'] as String?,
      ),
      contactInfo: ContactInfoModel(
        userName: json['userName'] as String? ?? '',
        userPhone: json['userPhone'] as String? ?? '',
      ),
      dishesCount: (json['dishesCount'] as num?)?.toInt(),
      foods: (json['foods'] as List<dynamic>?)
          ?.map((e) => FoodItemOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethod: json['paymentMethod'] as String?,
      price: (json['price'] as num?)?.toInt(),
      deliveryPrice: (json['deliveryPrice'] as num?)?.toInt(),
      sdacha: (json['sdacha'] as num?)?.toInt(),
    );
  }

  factory CreateOrderModel.fromEntity(CreateOrderEntity entity) => CreateOrderModel(
        addressData: AddressModel.fromEntity(entity.addressData),
        contactInfo: ContactInfoModel.fromEntity(entity.contactInfo),
        dishesCount: entity.dishesCount,
        foods: entity.foods.map((food) => FoodItemOrderModel.fromEntity(food)).toList(),
        paymentMethod: entity.paymentMethod,
        price: entity.price,
        deliveryPrice: entity.deliveryPrice,
        sdacha: entity.sdacha,
      );
}

extension CreateOrderModelX on CreateOrderModel {
  CreateOrderEntity toEntity() => CreateOrderEntity(
        addressData: addressData?.toEntity() ??
            const AddressEntity(
              address: '',
              houseNumber: '',
            ),
        contactInfo: contactInfo?.toEntity() ??
            const ContactInfoEntity(
              userName: '',
              userPhone: '',
            ),
        dishesCount: dishesCount ?? 0,
        foods: foods?.map((food) => food.toEntity()).toList() ?? [],
        paymentMethod: paymentMethod ?? '',
        price: price ?? 0,
        deliveryPrice: deliveryPrice ?? 0,
        sdacha: sdacha,
      );

  Map<String, dynamic> toJsonFlat() {
    final json = <String, dynamic>{};
    if (addressData != null) {
      json['address'] = addressData!.address;
      json['houseNumber'] = addressData!.houseNumber;
      if (addressData!.comment != null && addressData!.comment!.isNotEmpty) {
        json['comment'] = addressData!.comment;
      }
      if (addressData!.entrance != null && addressData!.entrance!.isNotEmpty) {
        json['entrance'] = addressData!.entrance;
      }
      if (addressData!.floor != null && addressData!.floor!.isNotEmpty) {
        json['floor'] = addressData!.floor;
      }
      if (addressData!.intercom != null && addressData!.intercom!.isNotEmpty) {
        json['intercom'] = addressData!.intercom;
      }
      if (addressData!.kvOffice != null && addressData!.kvOffice!.isNotEmpty) {
        json['kvOffice'] = addressData!.kvOffice;
      }
      if (addressData!.region != null && addressData!.region!.isNotEmpty) {
        json['region'] = addressData!.region;
      }
    }

    // Разворачиваем contactInfo
    // Всегда добавляем userName и userPhone в JSON (даже если пустые)
    // Это гарантирует, что поля всегда присутствуют в запросе
    final userNameValue = contactInfo?.userName ?? '';
    final userPhoneValue = contactInfo?.userPhone ?? '';
    json['userName'] = userNameValue;
    json['userPhone'] = userPhoneValue;

    // Остальные поля
    if (dishesCount != null) json['dishesCount'] = dishesCount;
    if (foods != null) json['foods'] = foods!.map((e) => e.toJson()).toList();
    if (paymentMethod != null) json['paymentMethod'] = paymentMethod;
    if (price != null) json['price'] = price;
    if (deliveryPrice != null) json['deliveryPrice'] = deliveryPrice;
    if (sdacha != null) json['sdacha'] = sdacha;

    return json;
  }
}
