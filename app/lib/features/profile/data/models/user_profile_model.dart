import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Модель пользователя для профиля (с балансом и другими данными)
@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    String? id,
    String? phone,
    String? userName,
    String? email,
    String? role,
    bool? active,
    double? balance, // Баланс бонусов
    int? discount,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
}
