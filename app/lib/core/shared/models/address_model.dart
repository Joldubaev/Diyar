import 'package:diyar/core/shared/models/address_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String address,
    required String houseNumber,
    String? entrance,
    String? floor,
    String? intercom,
    String? kvOffice,
    String? comment,
    String? region,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  factory AddressModel.fromEntity(AddressEntity entity) => AddressModel(
        address: entity.address,
        houseNumber: entity.houseNumber,
        entrance: entity.entrance,
        floor: entity.floor,
        intercom: entity.intercom,
        kvOffice: entity.kvOffice,
        comment: entity.comment,
        region: entity.region,
      );
}

extension AddressModelX on AddressModel {
  AddressEntity toEntity() => AddressEntity(
        address: address,
        houseNumber: houseNumber,
        entrance: entrance,
        floor: floor,
        intercom: intercom,
        kvOffice: kvOffice,
        comment: comment,
        region: region,
      );
}
