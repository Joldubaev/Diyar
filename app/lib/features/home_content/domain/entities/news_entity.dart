import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? photoLink;

  const NewsEntity({
    this.id,
    this.name,
    this.description,
    this.photoLink,
  });

  @override
  List<Object?> get props => [id, name, description, photoLink];
}
