import 'dart:convert';
import 'package:diyar/features/menu/domain/domain.dart';
import 'message_model.dart';

CategoryModel menuModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String menuModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  final int? code;
  final List<MessagModel>? message;

  CategoryModel({
    this.code,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message?.map((x) => x.toJson()).toList(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      code: map['code']?.toInt(),
      message:
          map['message'] != null ? List<MessagModel>.from(map['message']?.map((x) => MessagModel.fromJson(x))) : null,
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      code: entity.code,
      message: entity.message?.map((e) => MessagModel.fromEntity(e)).toList(),
    );
  }
  CategoryEntity toEntity() {
    return CategoryEntity(
      code: code,
      message: message?.map((e) => e.toEntity()).toList(),
    );
  }
}
