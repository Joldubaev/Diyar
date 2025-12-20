import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_model.freezed.dart';
// part 'template_model.g.dart'; // Будет сгенерирован после build_runner

@freezed
class TemplateModel with _$TemplateModel {
  const factory TemplateModel({
    String? id,
    required String templateName,
    required AddressModel addressData,
    required ContactInfoModel contactInfo,
    int? price, // Цена доставки на этот адрес
  }) = _TemplateModel;

  // Кастомный fromJson для преобразования плоской структуры API в композиционную
  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    // Если уже есть вложенные объекты, парсим их напрямую
    if (json.containsKey('addressData') || json.containsKey('contactInfo')) {
      return TemplateModel(
        id: json['id'] as String?,
        templateName: json['templateName'] as String,
        addressData: AddressModel.fromJson(json['addressData'] as Map<String, dynamic>),
        contactInfo: ContactInfoModel.fromJson(json['contactInfo'] as Map<String, dynamic>),
        price: (json['price'] as num?)?.toInt(),
      );
    }

    // Иначе собираем из плоской структуры
    return TemplateModel(
      id: json['id'] as String?,
      templateName: json['templateName'] as String,
      addressData: AddressModel(
        address: json['address'] as String? ?? '',
        houseNumber: json['houseNumber'] as String? ?? '',
        comment: json['comment'] as String?,
        entrance: json['entrance'] as String?,
        floor: json['floor'] as String?,
        intercom: json['intercom'] as String?,
        kvOffice: json['kvOffice'] as String?,
        region: json['region'] as String?,
      ),
      contactInfo: ContactInfoModel(
        userName: json['userName'] as String? ?? '',
        userPhone: json['userPhone'] as String? ?? '',
      ),
      price: (json['price'] as num?)?.toInt(),
    );
  }

  factory TemplateModel.fromEntity(TemplateEntity entity) => TemplateModel(
        id: entity.id,
        templateName: entity.templateName,
        addressData: AddressModel.fromEntity(entity.addressData),
        contactInfo: ContactInfoModel.fromEntity(entity.contactInfo),
        price: entity.price,
      );
}

extension TemplateModelX on TemplateModel {
  TemplateEntity toEntity() => TemplateEntity(
        id: id,
        templateName: templateName,
        addressData: addressData.toEntity(),
        contactInfo: contactInfo.toEntity(),
        price: price,
      );

  // Кастомный toJson для преобразования композиционной структуры в плоскую для API
  Map<String, dynamic> toJsonFlat() {
    final json = <String, dynamic>{};

    // Обязательные поля
    json['templateName'] = templateName;
    json['address'] = addressData.address;
    json['houseNumber'] = addressData.houseNumber;
    json['userName'] = contactInfo.userName;
    json['userPhone'] = contactInfo.userPhone;

    // Опциональные поля (отправляем только если не пустые)
    if (addressData.comment != null && addressData.comment!.isNotEmpty) {
      json['comment'] = addressData.comment;
    }
    if (addressData.entrance != null && addressData.entrance!.isNotEmpty) {
      json['entrance'] = addressData.entrance;
    }
    if (addressData.floor != null && addressData.floor!.isNotEmpty) {
      json['floor'] = addressData.floor;
    }
    if (addressData.intercom != null && addressData.intercom!.isNotEmpty) {
      json['intercom'] = addressData.intercom;
    }
    if (addressData.kvOffice != null && addressData.kvOffice!.isNotEmpty) {
      json['kvOffice'] = addressData.kvOffice;
    }

    // id отправляем только при обновлении (если не null)
    if (id != null) {
      json['id'] = id;
    }

    // Цена доставки (по умолчанию 0, если не указана)
    json['price'] = price ?? 0;

    return json;
  }
}
