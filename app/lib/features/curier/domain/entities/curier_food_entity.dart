import 'package:equatable/equatable.dart';

class CurierFoodEntity extends Equatable {
  final int? quantity;
  final String? name;
  final int? price;

  const CurierFoodEntity({
    this.quantity,
    this.name,
    this.price,
  });

  @override
  List<Object?> get props => [
        quantity,
        name,
        price,
      ];
}
