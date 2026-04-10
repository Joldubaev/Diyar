import 'package:equatable/equatable.dart';

class DeliveryPriceEntity extends Equatable {
  final String? districtId;
  final String? districtName;
  final int price;
  final int? yandexId;

  const DeliveryPriceEntity({
    this.districtId,
    this.districtName,
    required this.price,
    this.yandexId,
  });

  @override
  List<Object?> get props => [districtId, districtName, price, yandexId];
}
