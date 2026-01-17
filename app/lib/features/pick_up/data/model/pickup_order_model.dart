import 'package:diyar/core/core.dart';
import 'package:diyar/features/pick_up/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pickup_order_model.freezed.dart';
part 'pickup_order_model.g.dart';

@freezed
class PickupOrderModel with _$PickupOrderModel {
  const factory PickupOrderModel({
    int? dishesCount,
    List<FoodItemOrderModel>? foods,
    String? prepareFor,
    int? price,
    String? userName,
    String? userPhone,
    String? comment,
    String? paymentMethod,
    double? amountToReduce,
  }) = _PickupOrderModel;

  factory PickupOrderModel.fromJson(Map<String, dynamic> json) => _$PickupOrderModelFromJson(json);

  factory PickupOrderModel.fromEntity(PickupOrderEntity entity) => PickupOrderModel(
        dishesCount: entity.dishesCount,
        foods: entity.foods.map((foodEntity) => FoodItemOrderModel.fromEntity(foodEntity)).toList(),
        prepareFor: entity.prepareFor,
        price: entity.price,
        userName: entity.userName,
        userPhone: entity.userPhone,
        comment: entity.comment,
        paymentMethod: entity.paymentMethod,
        amountToReduce: entity.amountToReduce,
      );
}

extension PickupOrderModelX on PickupOrderModel {
  PickupOrderEntity toEntity() => PickupOrderEntity(
        dishesCount: dishesCount ?? 0,
        foods: foods?.map((foodModel) => foodModel.toEntity()).toList() ?? [],
        prepareFor: prepareFor ?? '',
        price: price ?? 0,
        userName: userName ?? '',
        userPhone: userPhone ?? '',
        comment: comment,
        paymentMethod: paymentMethod,
        amountToReduce: amountToReduce,
      );
}

/// Выносим логику формирования JSON для API в расширение-маппер
/// Это позволяет API менять структуру, не меняя нашу модель данных
extension PickupOrderApiExtension on PickupOrderModel {
  Map<String, dynamic> toApiJson() {
    // Убеждаемся, что userName и userPhone не null
    final userNameValue = userName ?? '';
    final userPhoneValue = userPhone ?? '';
    
    // Согласно документации API, данные отправляются в плоской структуре (без обертки dto)
    return <String, dynamic>{
      'userName': userNameValue,
      'userPhone': userPhoneValue,
      'foods': foods?.map((e) => e.toJson()).toList() ?? [],
      'prepareFor': prepareFor ?? '',
      'dishesCount': dishesCount ?? 0,
      'price': price ?? 0,
      if (comment != null && comment!.isNotEmpty) 'comment': comment,
      if (paymentMethod != null && paymentMethod!.isNotEmpty) 'paymentMethod': paymentMethod,
      // Включаем amountToReduce только если он не null и > 0
      if (amountToReduce != null && amountToReduce! > 0) 'amountToReduce': amountToReduce,
    };
  }
}
