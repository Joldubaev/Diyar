import 'package:diyar/core/components/components.dart';
import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/domain/entities/create_order_entity.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/order/presentation/widgets/delivery_form_controllers.dart';
import 'package:flutter/material.dart';

/// Утилита для создания сущностей из контроллеров формы
class OrderConfirmationHelper {
  /// Создает AddressEntity из контроллеров формы
  static AddressEntity createAddressEntity({
    required TextEditingController addressController,
    required TextEditingController houseController,
    required TextEditingController commentController,
    required TextEditingController entranceController,
    required TextEditingController floorController,
    required TextEditingController intercomController,
    required TextEditingController apartmentController,
    String? region,
  }) {
    return AddressEntity(
      address: addressController.text,
      houseNumber: houseController.text,
      comment: commentController.text.isEmpty ? null : commentController.text,
      entrance: entranceController.text.isEmpty ? null : entranceController.text,
      floor: floorController.text.isEmpty ? null : floorController.text,
      intercom: intercomController.text.isEmpty ? null : intercomController.text,
      kvOffice: apartmentController.text.isEmpty ? null : apartmentController.text,
      region: region,
    );
  }

  /// Создает ContactInfoEntity из контроллеров формы
  static ContactInfoEntity createContactInfoEntity({
    required TextEditingController userName,
    required TextEditingController phoneController,
  }) {
    return ContactInfoEntity(
      userName: userName.text.trim(),
      userPhone: phoneController.text.trim(),
    );
  }

  /// Создает CreateOrderEntity из данных формы
  static CreateOrderEntity createOrderEntity({
    required List<CartItemEntity> cart,
    required int totalPrice,
    required int deliveryPrice,
    required int dishCount,
    required int sdacha,
    required PaymentTypeDelivery paymentType,
    required DeliveryFormControllers controllers,
    String? region,
  }) {
    final addressData = createAddressEntity(
      addressController: controllers.addressController,
      houseController: controllers.houseController,
      commentController: controllers.commentController,
      entranceController: controllers.entranceController,
      floorController: controllers.floorController,
      intercomController: controllers.intercomController,
      apartmentController: controllers.apartmentController,
      region: region,
    );

    final contactInfo = createContactInfoEntity(
      userName: controllers.userName,
      phoneController: controllers.phoneController,
    );

    return CreateOrderEntity(
      addressData: addressData,
      contactInfo: contactInfo,
      price: totalPrice,
      deliveryPrice: deliveryPrice,
      paymentMethod: paymentType.name,
      dishesCount: dishCount,
      sdacha: sdacha,
      foods: cart
          .map(
            (e) => FoodItemOrderEntity(
              dishId: '${e.food?.id}',
              name: e.food?.name ?? '',
              price: e.food?.price ?? 0,
              quantity: e.quantity ?? 1,
            ),
          )
          .toList(),
    );
  }
}

