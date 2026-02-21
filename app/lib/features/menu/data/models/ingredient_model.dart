import 'package:diyar/features/menu/domain/domain.dart';

class IngredientModel {
  final String? id;
  final String? name;
  final String? urlPhoto;

  const IngredientModel({
    this.id,
    this.name,
    this.urlPhoto,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) => IngredientModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        urlPhoto: json['urlPhoto'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'urlPhoto': urlPhoto,
      };

  factory IngredientModel.fromEntity(IngredientEntity entity) => IngredientModel(
        id: entity.id,
        name: entity.name,
        urlPhoto: entity.urlPhoto,
      );

  IngredientEntity toEntity() => IngredientEntity(
        id: id,
        name: name,
        urlPhoto: urlPhoto,
      );
}
