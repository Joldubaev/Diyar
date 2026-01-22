import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/order_detail/domain/entities/order_detail_entity.dart';

/// Маппер для конвертации различных сущностей заказов в OrderDetailEntity
class OrderDetailMapper {
  /// Конвертирует OrderActiveItemEntity в OrderDetailEntity
  static OrderDetailEntity fromActiveOrder(OrderActiveItemEntity order) {
    return OrderDetailEntity(
      id: order.id,
      userId: order.userId,
      userName: order.userName,
      userPhone: order.userPhone,
      orderNumber: order.orderNumber,
      dishesCount: order.dishesCount,
      foods: order.foods
          ?.map((food) => OrderDetailFoodItem(
                name: food.name ?? '',
                quantity: food.quantity ?? 0,
                price: food.price,
              ))
          .toList(),
      address: order.address,
      houseNumber: order.houseNumber,
      kvOffice: order.kvOffice,
      intercom: order.intercom,
      floor: order.floor,
      entrance: order.entrance,
      comment: order.comment,
      paymentMethod: order.paymentMethod,
      price: order.price,
      timeRequest: order.timeRequest,
      courierId: order.courierId,
      status: order.status,
      deliveryPrice: order.deliveryPrice,
      sdacha: order.sdacha,
      amountToReduce: order.amountToReduce?.toDouble(),
    );
  }

  /// Конвертирует CurierEntity в OrderDetailEntity
  static OrderDetailEntity fromCurierOrder(CurierEntity order) {
    return OrderDetailEntity(
      id: order.id,
      userId: order.userId,
      userName: order.userName,
      userPhone: order.userPhone,
      orderNumber: order.orderNumber,
      dishesCount: order.dishesCount,
      foods: order.foods
          ?.map((food) => OrderDetailFoodItem(
                name: food.name ?? '',
                quantity: food.quantity ?? 0,
                price: food.price,
              ))
          .toList(),
      address: order.address,
      houseNumber: order.houseNumber,
      kvOffice: order.kvOffice,
      intercom: order.intercom,
      floor: order.floor,
      entrance: order.entrance,
      comment: order.comment,
      paymentMethod: order.paymentMethod,
      price: order.price,
      timeRequest: order.timeRequest,
      courierId: order.courierId,
      status: order.status,
      deliveryPrice: order.deliveryPrice,
      sdacha: order.sdacha,
      amountToReduce: order.amountToReduce?.toDouble(),
    );
  }
}
