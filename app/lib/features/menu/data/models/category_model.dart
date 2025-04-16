import 'dart:convert';

import 'food_model.dart';

CategoryModel menuModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String menuModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryName? category;
  List<FoodModel>? foods;

  CategoryModel({this.category, this.foods});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        category: json["Category"] == null
            ? null
            : CategoryName.fromJson(json["Category"]),
        foods: json["Foods"] == null
            ? []
            : List<FoodModel>.from(
                json["Foods"]!.map((x) => FoodModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Category": category?.toJson(),
        "Foods": foods == null
            ? []
            : List<dynamic>.from(foods!.map((x) => x.toJson())),
      };
}

class CategoryName {
  String? name;

  CategoryName({this.name});

  factory CategoryName.fromJson(Map<String, dynamic> json) =>
      CategoryName(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}
