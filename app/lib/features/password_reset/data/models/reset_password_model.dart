import 'package:diyar/features/password_reset/domain/entities/reset_password_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_model.freezed.dart';
part 'reset_password_model.g.dart';

@freezed
class ResetPasswordModel with _$ResetPasswordModel {
  const factory ResetPasswordModel({
    String? phone,
    String? newPassword,
    int? code,
  }) = _ResetPasswordModel;

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);

  factory ResetPasswordModel.fromEntity(ResetPasswordEntity entity) =>
      ResetPasswordModel(
        phone: entity.phone,
        newPassword: entity.newPassword,
        code: entity.code,
      );
}

extension ResetPasswordModelX on ResetPasswordModel {
  ResetPasswordEntity toEntity() => ResetPasswordEntity(
        phone: phone,
        newPassword: newPassword,
        code: code,
      );
}

