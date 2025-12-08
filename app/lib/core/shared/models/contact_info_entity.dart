import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info_entity.freezed.dart';

@freezed
class ContactInfoEntity with _$ContactInfoEntity {
  const factory ContactInfoEntity({
    required String userName,
    required String userPhone,
  }) = _ContactInfoEntity;
}
