import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_model.freezed.dart';
part 'sale_model.g.dart';

@freezed
class SaleModel with _$SaleModel {
  const factory SaleModel({
    String? id,
    String? name,
    String? description,
    String? photoLink,
    int? discount,
  }) = _SaleModel;

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);

  factory SaleModel.fromEntity(SaleEntity entity) => SaleModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        photoLink: entity.photoLink,
        discount: entity.discount,
      );
}

extension SaleModelX on SaleModel {
  SaleEntity toEntity() => SaleEntity(
        id: id,
        name: name,
        description: description,
        photoLink: photoLink,
        dateStart: null,
        dateEnd: null,
        discount: discount,
      );
}
