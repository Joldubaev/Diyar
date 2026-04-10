import 'package:equatable/equatable.dart';

class AllergenEntity extends Equatable {
  final String? id;
  final String? name;
  final int? sortOrder;

  const AllergenEntity({
    this.id,
    this.name,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [id, name, sortOrder];

  AllergenEntity copyWith({
    String? id,
    String? name,
    int? sortOrder,
  }) =>
      AllergenEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
      );
}
