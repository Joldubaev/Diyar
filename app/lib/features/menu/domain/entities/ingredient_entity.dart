class IngredientEntity {
  final String? id;
  final String? name;
  final String? urlPhoto;

  IngredientEntity({
    this.id,
    this.name,
    this.urlPhoto,
  });

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
