import 'package:diyar/features/auth/domain/entities/reset_password_entity.dart';

class ResetPasswordModel extends ResetPasswordEntity {
  ResetPasswordModel({
     super.phone,
    super.newPassword,
    super.code,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      phone: json['phone'] as String,
      newPassword: json['newPassword'] as String?,
      code: json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'newPassword': newPassword,
      'code': code,
    };
  }

    factory ResetPasswordModel.fromEntity(ResetPasswordEntity entity) {
    return ResetPasswordModel(
      phone: entity.phone,
      newPassword: entity.newPassword,
      code: entity.code,
    );
  }


  ResetPasswordEntity toEntity() {
    return ResetPasswordEntity(
      phone: phone,
      newPassword: newPassword,
      code: code,
    );
  }
}
