import 'package:equatable/equatable.dart';

class IngredientEntity extends Equatable {
  final String? id;
  final String? name;
  final String? urlPhoto;

  const IngredientEntity({
    this.id,
    this.name,
    this.urlPhoto,
  });

  @override
  List<Object?> get props => [id, name, urlPhoto];

  IngredientEntity copyWith({
    String? id,
    String? name,
    String? urlPhoto,
  }) =>
      IngredientEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        urlPhoto: urlPhoto ?? this.urlPhoto,
      );
}
