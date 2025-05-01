import 'package:diyar/features/home_content/domain/entities/sale_entity.dart';
import 'package:equatable/equatable.dart';

class SaleModel extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? photoLink;
  final int? discount;

  const SaleModel({
    this.id,
    this.name,
    this.description,
    this.photoLink,
    this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photoLink': photoLink,
      'discount': discount,
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      photoLink: json['photoLink'] as String?,
      discount: json['discount'] as int?,
    );
  }

  SaleEntity toEntity() => SaleEntity(
        id: id,
        name: name,
        description: description,
        photoLink: photoLink,
        dateStart: null,
        dateEnd: null,
        discount: discount,
      );

  @override
  List<Object?> get props => [id, name, description, photoLink, discount];
}
