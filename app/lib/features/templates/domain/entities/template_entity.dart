import 'package:diyar/core/shared/shared.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_entity.freezed.dart';

@freezed
class TemplateEntity with _$TemplateEntity {
  const factory TemplateEntity({
    String? id,
    required String templateName,
    required AddressEntity addressData,
    required ContactInfoEntity contactInfo,
  }) = _TemplateEntity;
}
