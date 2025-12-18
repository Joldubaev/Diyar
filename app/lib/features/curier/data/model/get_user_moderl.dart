import 'package:diyar/features/curier/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_moderl.freezed.dart';
part 'get_user_moderl.g.dart';

@freezed
class GetUserModel with _$GetUserModel {
  const factory GetUserModel(
      {String? id, String? userName, String? email, String? phone, String? role, int? discount}) = _GetUserModel;

  factory GetUserModel.fromJson(Map<String, dynamic> json) => _$GetUserModelFromJson(json);

  factory GetUserModel.fromEntity(GetUserEntity entity) => GetUserModel(
        id: entity.id,
        userName: entity.userName,
        email: entity.email,
        phone: entity.phone,
        role: entity.role,
        discount: entity.discount,
      );
}

extension GetUserModelX on GetUserModel {
  GetUserEntity toEntity() => GetUserEntity(
        id: id,
        userName: userName,
        email: email,
        phone: phone,
        role: role,
        discount: discount,
      );
}
