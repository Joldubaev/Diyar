import 'package:equatable/equatable.dart';

class FoodPickUpEntity extends Equatable {
  final int? quantity;
  final String? name;
  final int? price;

  const FoodPickUpEntity({
    this.quantity,
    this.name,
    this.price,
  });

  @override
  List<Object?> get props => [quantity, name, price];
}
