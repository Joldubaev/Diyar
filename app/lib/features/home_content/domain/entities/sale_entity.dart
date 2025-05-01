import 'package:equatable/equatable.dart';

class SaleEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? photoLink;
  final DateTime? dateStart;
  final DateTime? dateEnd;
    final int? discount;

  const SaleEntity({
    this.id,
    this.name,
    this.description,
    this.photoLink,
    this.dateStart,
    this.dateEnd,
    this.discount,
  });

  @override
  List<Object?> get props => [id, name, description, photoLink, dateStart, dateEnd, discount];
}
