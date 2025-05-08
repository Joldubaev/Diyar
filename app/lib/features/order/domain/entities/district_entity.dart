import 'package:equatable/equatable.dart';

class DistrictEntity extends Equatable {
  final String name;
  final int price; // Цена доставки в этот район
  // final String id; // Если у района есть ID, его тоже можно добавить

  const DistrictEntity({
    required this.name,
    required this.price,
    // this.id,
  });

  @override
  List<Object?> get props => [name, price /*, id */];
}
