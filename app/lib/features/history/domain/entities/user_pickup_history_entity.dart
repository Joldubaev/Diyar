import 'package:equatable/equatable.dart';

import 'food_pick_up_entity.dart';

class UserPickupHistoryEntity extends Equatable {
  final int? dishesCount;
  final String? comment;
  final List<FoodPickUpEntity>? foods;
  final String? id;
  final int? orderNumber;
  final String? prepareFor;
  final int? price;
  final String? status;
  final String? timeRequest;
  final String? userId;
  final String? userName;
  final String? userPhone;

  const UserPickupHistoryEntity({
    this.comment,
    this.dishesCount,
    this.foods,
    this.id,
    this.orderNumber,
    this.prepareFor,
    this.price,
    this.status,
    this.timeRequest,
    this.userId,
    this.userName,
    this.userPhone,
  });

  @override
  List<Object?> get props => [
        comment,
        dishesCount,
        foods,
        id,
        orderNumber,
        prepareFor,
        price,
        status,
        timeRequest,
        userId,
        userName,
        userPhone,
      ];
}
