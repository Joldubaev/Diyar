import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entities.freezed.dart';

@freezed
class UserEntities with _$UserEntities {
  const factory UserEntities({
    required String phone,
    String? userName,
  }) = _UserEntities;
}
