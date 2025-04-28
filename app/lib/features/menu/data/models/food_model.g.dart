// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodModelAdapter extends TypeAdapter<FoodModel> {
  @override
  final int typeId = 1;

  @override
  FoodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      categoryId: fields[3] as String?,
      price: fields[4] as int?,
      weight: fields[5] as String?,
      urlPhoto: fields[6] as String?,
      stopList: fields[7] as bool?,
      iDctMax: fields[8] as int?,
      containerName: fields[9] as String?,
      containerCount: fields[10] as int?,
      quantity: fields[11] as int?,
      containerPrice: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.urlPhoto)
      ..writeByte(7)
      ..write(obj.stopList)
      ..writeByte(8)
      ..write(obj.iDctMax)
      ..writeByte(9)
      ..write(obj.containerName)
      ..writeByte(10)
      ..write(obj.containerCount)
      ..writeByte(11)
      ..write(obj.quantity)
      ..writeByte(12)
      ..write(obj.containerPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
