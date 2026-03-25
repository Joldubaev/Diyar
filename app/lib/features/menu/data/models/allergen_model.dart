import 'package:diyar/features/menu/domain/domain.dart';

class AllergenModel {
  final String? id;
  final String? name;
  final int? sortOrder;

  const AllergenModel({
    this.id,
    this.name,
    this.sortOrder,
  });

  factory AllergenModel.fromJson(Map<String, dynamic> json) => AllergenModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        sortOrder: (json['sortOrder'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'sortOrder': sortOrder,
      };

  factory AllergenModel.fromEntity(AllergenEntity entity) => AllergenModel(
        id: entity.id,
        name: entity.name,
        sortOrder: entity.sortOrder,
      );

  AllergenEntity toEntity() => AllergenEntity(
        id: id,
        name: name,
        sortOrder: sortOrder,
      );
}
