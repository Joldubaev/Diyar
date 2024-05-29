import 'package:diyar/features/menu/menu.dart';

class OrderModel {
  final String? id;
  final List<FoodModel>? foods;
  final String? address;
  final String? status;

  OrderModel({this.id, this.foods, this.address, this.status});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      foods: json['foods'] != null ? (json['foods'] as List).map((i) => FoodModel.fromJson(i)).toList() : null,
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
}
