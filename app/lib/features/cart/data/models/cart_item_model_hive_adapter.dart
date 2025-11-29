import 'dart:convert';
import 'package:hive/hive.dart';
import 'cart_item_model.dart';

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 0;

  @override
  CartItemModel read(BinaryReader reader) {
    final jsonString = reader.readString();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return CartItemModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    // Используем кастомный toJson для обратной совместимости с ключом 'price'
    final jsonString = jsonEncode(obj.toJsonCustom());
    writer.writeString(jsonString);
  }
}
