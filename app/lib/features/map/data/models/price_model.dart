import 'package:diyar/features/map/domain/entities/delivery_price_entity.dart';

class PriceModel {
  final String? districtId;
  final String? districtName;
  final int? price;
  final int? yandexId;

  PriceModel({
    this.districtId,
    this.districtName,
    this.price,
    this.yandexId,
  });

  Map<String, dynamic> toJson() {
    return {
      'districtId': districtId,
      'districtName': districtName,
      'price': price,
      'yandexId': yandexId,
    };
  }

  factory PriceModel.fromJson(Map<String, dynamic> map) {
    return PriceModel(
      districtId: map['districtId'],
      districtName: map['districtName'],
      price: map['price']?.toInt(),
      yandexId: map['yandexId']?.toInt(),
    );
  }

  DeliveryPriceEntity toEntity() => DeliveryPriceEntity(
        districtId: districtId,
        districtName: districtName,
        price: price ?? 0,
        yandexId: yandexId,
      );
}
