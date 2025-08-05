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

  PriceModel copyWith({
    String? districtId,
    String? districtName,
    int? price,
    int? yandexId,
  }) =>
      PriceModel(
        districtId: districtId ?? this.districtId,
        districtName: districtName ?? this.districtName,
        price: price ?? this.price,
        yandexId: yandexId ?? this.yandexId,
      );

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
}
