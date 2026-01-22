import 'package:diyar/features/history/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'food_pick_up_model.dart';

part 'user_pickup_history_model.freezed.dart';
part 'user_pickup_history_model.g.dart';

@freezed
class UserPickupHistoryModel with _$UserPickupHistoryModel {
  const factory UserPickupHistoryModel({
    String? comment,
    int? dishesCount,
    List<FoodPickupModel>? foods,
    String? id,
    int? orderNumber,
    String? prepareFor,
    int? price,
    String? status,
    String? timeRequest,
    String? userId,
    String? userName,
    String? userPhone,
    String? paymentMethod,
    double? amountToReduce,
  }) = _UserPickupHistoryModel;

  factory UserPickupHistoryModel.fromJson(Map<String, dynamic> json) => _$UserPickupHistoryModelFromJson(json);

  factory UserPickupHistoryModel.fromEntity(UserPickupHistoryEntity entity) => UserPickupHistoryModel(
        comment: entity.comment,
        dishesCount: entity.dishesCount,
        foods: entity.foods?.map((food) => FoodPickupModel.fromEntity(food)).toList(),
        id: entity.id,
        orderNumber: entity.orderNumber,
        prepareFor: entity.prepareFor,
        price: entity.price,
        status: entity.status,
        timeRequest: entity.timeRequest,
        userId: entity.userId,
        userName: entity.userName,
        userPhone: entity.userPhone,
        paymentMethod: entity.paymentMethod,
        amountToReduce: entity.amountToReduce,
      );
}

extension UserPickupHistoryModelX on UserPickupHistoryModel {
  UserPickupHistoryEntity toEntity() => UserPickupHistoryEntity(
        comment: comment,
        dishesCount: dishesCount,
        foods: foods?.map((food) => food.toEntity()).toList(),
        id: id,
        orderNumber: orderNumber,
        prepareFor: prepareFor,
        price: price,
        status: status,
        timeRequest: timeRequest,
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        paymentMethod: paymentMethod,
        amountToReduce: amountToReduce,
      );
}
