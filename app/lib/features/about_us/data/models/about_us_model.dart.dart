import 'dart:convert';
import 'package:diyar/features/about_us/domain/domain.dart';

class AboutUsModel {
  AboutUsModel({
    this.name,
    this.description,
    this.photoLinks,
  });

  final String? name;
  final String? description;
  final List? photoLinks;

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        name: json['name'],
        description: json['description'],
        photoLinks: json['photoLinks'] == null ? [] : List<String>.from(jsonDecode(json['photoLinks'])),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'photoLinks': photoLinks == null ? null : List<dynamic>.from(photoLinks!.map((x) => x.toJson())),
      };

  factory AboutUsModel.fromEntity(AboutUsEntities entity) {
    return AboutUsModel(
      name: entity.name,
      description: entity.description,
      photoLinks: entity.photoLinks,
    );
  }

  AboutUsEntities toEntity() {
    return AboutUsEntities(
      name: name ?? '',
      description: description ?? '',
      photoLinks: photoLinks ?? [],
    );
  }
}
