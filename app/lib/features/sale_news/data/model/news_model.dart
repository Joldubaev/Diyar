import 'package:equatable/equatable.dart';

class NewsModel extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? photoLink;

  const NewsModel({
    this.id,
    this.name,
    this.description,
    this.photoLink,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"] as String?,
        name: json["name"] as String?,
        description: json["description"] as String?,
        photoLink: json["photoLink"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoLink": photoLink,
      };

  @override
  List<Object?> get props => [id, name, description, photoLink];
}
