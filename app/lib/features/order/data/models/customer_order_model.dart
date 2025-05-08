import 'package:diyar/features/features.dart';

class CustomerOrderModel {
  final String? id;
  final List<FoodModel>? foods;
  final String? address;
  final String? status;

  CustomerOrderModel({this.id, this.foods, this.address, this.status});

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderModel(
      id: json['id'],
      foods: json['foods'] != null
          ? (json['foods'] as List).map((i) => FoodModel.fromJson(i)).toList()
          : null,
      address: json['address'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foods': foods?.map((e) => e.toJson()).toList(),
      'address': address,
      'status': status,
    };
  }

  factory CustomerOrderModel.fromEntity(CustomerOrderEntity entity) {
    return CustomerOrderModel(
      id: entity.id,
      foods: entity.foods?.map((foodEntity) => FoodModel.fromEntity(foodEntity)).toList(),
      address: entity.address,
      status: entity.status,
    );
  }
  CustomerOrderEntity toEntity() {
    return CustomerOrderEntity(
      id: id,
      foods: foods?.map((foodModel) => foodModel.toEntity()).toList(),
      address: address,
      status: status,
    );
  }
}
