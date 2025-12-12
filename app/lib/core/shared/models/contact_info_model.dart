import 'package:diyar/core/shared/models/contact_info_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info_model.freezed.dart';
part 'contact_info_model.g.dart';

@freezed
class ContactInfoModel with _$ContactInfoModel {
  const factory ContactInfoModel({
    required String userName,
    required String userPhone,
  }) = _ContactInfoModel;

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) => _$ContactInfoModelFromJson(json);

  factory ContactInfoModel.fromEntity(ContactInfoEntity entity) => ContactInfoModel(
        userName: entity.userName,
        userPhone: entity.userPhone,
      );
}

extension ContactInfoModelX on ContactInfoModel {
  ContactInfoEntity toEntity() => ContactInfoEntity(
        userName: userName,
        userPhone: userPhone,
      );
}
