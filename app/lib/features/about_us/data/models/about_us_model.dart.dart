import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:equatable/equatable.dart';

class AboutUsModel extends Equatable {
  const AboutUsModel({
    this.name,
    this.description,
    this.photoLinks,
  });

  final String? name;
  final String? description;
  final List<String>? photoLinks;

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    final photosJson = json['photoLinks'];
    List<String>? parsedPhotoLinks;
    if (photosJson is List) {
      parsedPhotoLinks = photosJson.map((item) => item.toString()).toList();
    } else {
      parsedPhotoLinks = [];
    }

    return AboutUsModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      photoLinks: parsedPhotoLinks,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'photoLinks': photoLinks,
      };

  factory AboutUsModel.fromEntity(AboutUsEntities entity) {
    return AboutUsModel(
      name: entity.name,
      description: entity.description,
      photoLinks: entity.photoLinks?.map((item) => item.toString()).toList(),
    );
  }

  AboutUsEntities toEntity() {
    return AboutUsEntities(
      name: name ?? '',
      description: description ?? '',
      photoLinks: photoLinks ?? [],
    );
  }

  @override
  List<Object?> get props => [name, description, photoLinks];
}
