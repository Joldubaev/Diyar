import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'district_data_model.freezed.dart';
part 'district_data_model.g.dart';

@freezed
class DistrictDataModel with _$DistrictDataModel {
  const factory DistrictDataModel({
    String? id,
    String? name,
    dynamic price,
  }) = _DistrictDataModel;

  factory DistrictDataModel.fromJson(Map<String, dynamic> json) =>
      _$DistrictDataModelFromJson(json);
}

extension DistrictDataModelX on DistrictDataModel {
  DistrictEntity toEntity() {
    int parsedPrice;
    if (price is int) {
      parsedPrice = price as int;
    } else if (price is String) {
      parsedPrice = int.tryParse(price as String) ?? 0;
    } else {
      parsedPrice = 0;
    }

    if (name == null) {
      throw Exception('DistrictDataModel toEntity Error: name is null.');
    }

    return DistrictEntity(
      name: name!,
      price: parsedPrice,
    );
  }
}
