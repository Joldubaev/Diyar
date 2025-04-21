import 'dart:convert';

import 'package:diyar/core/core.dart';
import 'package:diyar/features/menu/data/data.dart';

abstract class MenuLocalDataSource {
  Future<List<FoodModel>> getProducts({String? foodName});
  Future<List<FoodModel>> getPopularFoods();
  Future<List<FoodModel>> searchFoods({String? query});
  Future<List<CategoryModel>> getFoodsByCategory();
}

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final LocalStorage _localStorage;
  MenuLocalDataSourceImpl(this._localStorage);

  @override
  Future<List<CategoryModel>> getFoodsByCategory() async {
    final jsonString = _localStorage.getString(AppConst.kCachedCategories);
    if (jsonString != null) {
      final List list = jsonDecode(jsonString);
      return list.map((e) => CategoryModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<FoodModel>> getProducts({String? foodName}) async {
    final jsonString = _localStorage.getString(AppConst.kCachedFoods);
    if (jsonString != null) {
      final List list = jsonDecode(jsonString);
      final allFoods = list.map((e) => FoodModel.fromJson(e)).toList();
      if (foodName != null && foodName.isNotEmpty) {
        return allFoods.where((f) => f.name != null && f.name!.toLowerCase().contains(foodName.toLowerCase())).toList();
      }
      return allFoods;
    }
    return [];
  }

  @override
  Future<List<FoodModel>> getPopularFoods() async {
    final jsonString = _localStorage.getString(AppConst.kCachedPopularFoods);
    if (jsonString != null) {
      final List list = jsonDecode(jsonString);
      return list.map((e) => FoodModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<FoodModel>> searchFoods({String? query}) async {
    return getProducts(foodName: query);
  }
}
