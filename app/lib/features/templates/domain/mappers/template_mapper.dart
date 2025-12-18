import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';

/// Данные формы для создания/обновления шаблона
class TemplateFormData {
  final String templateName;
  final String address;
  final String houseNumber;
  final String? entrance;
  final String? floor;
  final String? intercom;
  final String? kvOffice;
  final String? comment;
  final String userName;
  final String userPhone;

  const TemplateFormData({
    required this.templateName,
    required this.address,
    required this.houseNumber,
    this.entrance,
    this.floor,
    this.intercom,
    this.kvOffice,
    this.comment,
    required this.userName,
    required this.userPhone,
  });
}

/// Mapper для преобразования данных формы в TemplateEntity
class TemplateMapper {
  /// Создает AddressEntity из данных формы
  ///
  /// Обрабатывает пустые строки, преобразуя их в null для optional полей
  static AddressEntity buildAddressEntity({
    required String address,
    required String houseNumber,
    String? entrance,
    String? floor,
    String? intercom,
    String? kvOffice,
    String? comment,
  }) {
    return AddressEntity(
      address: address,
      houseNumber: houseNumber,
      entrance: _nullIfEmpty(entrance),
      floor: _nullIfEmpty(floor),
      intercom: _nullIfEmpty(intercom),
      kvOffice: _nullIfEmpty(kvOffice),
      comment: _nullIfEmpty(comment),
    );
  }

  /// Создает ContactInfoEntity из данных формы
  ///
  /// Очищает номер телефона от нецифровых символов
  static ContactInfoEntity buildContactInfoEntity({
    required String userName,
    required String userPhone,
  }) {
    return ContactInfoEntity(
      userName: userName,
      userPhone: _cleanPhoneNumber(userPhone),
    );
  }

  /// Создает TemplateEntity из данных формы
  ///
  /// [formData] - данные формы
  /// [id] - ID шаблона (null для создания нового, значение для обновления)
  /// [price] - Цена доставки на этот адрес (опционально)
  static TemplateEntity buildTemplateEntity({
    required TemplateFormData formData,
    String? id,
    int? price,
  }) {
    return TemplateEntity(
      id: id,
      templateName: formData.templateName,
      addressData: buildAddressEntity(
        address: formData.address,
        houseNumber: formData.houseNumber,
        entrance: formData.entrance,
        floor: formData.floor,
        intercom: formData.intercom,
        kvOffice: formData.kvOffice,
        comment: formData.comment,
      ),
      contactInfo: buildContactInfoEntity(
        userName: formData.userName,
        userPhone: formData.userPhone,
      ),
      price: price,
    );
  }

  /// Преобразует пустую строку в null для optional полей
  static String? _nullIfEmpty(String? value) {
    return value?.isEmpty == true ? null : value;
  }

  /// Очищает номер телефона от нецифровых символов
  static String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
