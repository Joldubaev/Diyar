import 'package:diyar/features/order/domain/entities/entities.dart';

class DistrictDataModel {
  final String? id;
  final String? name;
  final dynamic price;

  DistrictDataModel({
    this.id,
    this.name,
    this.price,
  });

  DistrictDataModel copyWith({
    String? id,
    String? name,
    dynamic price,
  }) =>
      DistrictDataModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory DistrictDataModel.fromJson(Map<String, dynamic> json) {
    return DistrictDataModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  DistrictEntity toEntity() {
    int parsedPrice;
    if (price is int) {
      parsedPrice = price;
    } else if (price is String) {
      parsedPrice = int.tryParse(price) ?? 0;
    } else {
      parsedPrice = 0;
    }

    if (name == null) {
      throw Exception('DistrictDataModel toEntity Error: name is null.');
    }

    return DistrictEntity(
      name: name!,
      price: parsedPrice,
    );
  }
}
