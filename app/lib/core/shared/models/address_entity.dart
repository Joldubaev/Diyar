import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_entity.freezed.dart';

@freezed
class AddressEntity with _$AddressEntity {
  const factory AddressEntity({
    required String address,
    required String houseNumber,
    String? entrance,
    String? floor,
    String? intercom,
    String? kvOffice,
    String? comment,
    String? region,
  }) = _AddressEntity;
}
