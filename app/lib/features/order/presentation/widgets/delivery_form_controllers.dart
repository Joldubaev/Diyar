import 'package:flutter/material.dart';

/// Класс для управления всеми TextEditingController формы доставки
/// Инкапсулирует создание и управление жизненным циклом контроллеров
class DeliveryFormControllers {
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController houseController;
  final TextEditingController apartmentController;
  final TextEditingController intercomController;
  final TextEditingController floorController;
  final TextEditingController entranceController;
  final TextEditingController commentController;
  final TextEditingController userName;
  final TextEditingController sdachaController;

  DeliveryFormControllers({
    String? initialPhone,
    String? initialUserName,
    String? initialAddress,
    String? initialHouseNumber,
  })  : phoneController = TextEditingController(text: initialPhone ?? '+996'),
        userName = TextEditingController(text: initialUserName ?? ''),
        addressController = TextEditingController(text: initialAddress ?? ''),
        houseController = TextEditingController(text: initialHouseNumber ?? ''),
        apartmentController = TextEditingController(),
        intercomController = TextEditingController(),
        floorController = TextEditingController(),
        entranceController = TextEditingController(),
        commentController = TextEditingController(),
        sdachaController = TextEditingController();

  /// Обновление значений контроллеров из начальных данных
  void updateFromInitials({
    String? phone,
    String? userName,
    String? address,
    String? houseNumber,
  }) {
    if (phone != null && phone.isNotEmpty && phoneController.text.isEmpty) {
      phoneController.text = phone;
    }
    if (userName != null && userName.isNotEmpty && this.userName.text.isEmpty) {
      this.userName.text = userName;
    }
    if (address != null && address.isNotEmpty && addressController.text.isEmpty) {
      addressController.text = address;
    }
    if (houseNumber != null && houseNumber.isNotEmpty && houseController.text.isEmpty) {
      houseController.text = houseNumber;
    }
  }

  /// Очистка всех контроллеров
  void clearAll() {
    phoneController.clear();
    userName.clear();
    addressController.clear();
    houseController.clear();
    apartmentController.clear();
    intercomController.clear();
    floorController.clear();
    entranceController.clear();
    commentController.clear();
    sdachaController.clear();
  }

  /// Освобождение всех ресурсов
  void dispose() {
    phoneController.dispose();
    userName.dispose();
    addressController.dispose();
    houseController.dispose();
    apartmentController.dispose();
    intercomController.dispose();
    floorController.dispose();
    entranceController.dispose();
    commentController.dispose();
    sdachaController.dispose();
  }
}
