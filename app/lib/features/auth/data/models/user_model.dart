import 'package:diyar/features/auth/domain/entities/user_entities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? phone,
    String? userName,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntities entity) => UserModel(
        phone: entity.phone,
        userName: entity.userName,
      );
}

extension UserModelX on UserModel {
  Map<String, dynamic> toRegister() => {
        'userName': userName,
        'phone': phone,
      };

  Map<String, dynamic> toLogin() => {
        'phone': phone?.toString() ?? '',
      };

  UserEntities toEntity() => UserEntities(
        phone: phone ?? '',
        userName: userName,
      );
}
