import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/foundation.dart';

class CategoryModel {
  final String? id;
  final String? name;

  CategoryModel({
    this.id,
    this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id ?? '',
      name: name ?? '',
    );
  }

  CategoryModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? name,
  }) {
    return CategoryModel(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
    );
  }
}
