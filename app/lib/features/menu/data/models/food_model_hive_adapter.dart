import 'dart:convert';
import 'package:hive/hive.dart';
import 'food_model.dart';

class FoodModelAdapter extends TypeAdapter<FoodModel> {
  @override
  final int typeId = 1;

  @override
  FoodModel read(BinaryReader reader) {
    final jsonString = reader.readString();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return FoodModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, FoodModel obj) {
    final jsonString = jsonEncode(obj.toJson());
    writer.writeString(jsonString);
  }
}

