import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'about_us_model.freezed.dart';
part 'about_us_model.g.dart';

@freezed
class AboutUsModel with _$AboutUsModel {
  const factory AboutUsModel({
    String? name,
    String? description,
    List<String>? photoLinks,
  }) = _AboutUsModel;

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => _$AboutUsModelFromJson(json);

  factory AboutUsModel.fromEntity(AboutUsEntities entity) => AboutUsModel(
        name: entity.name,
        description: entity.description,
        photoLinks: entity.photoLinks?.map((item) => item.toString()).toList(),
      );
}

extension AboutUsModelX on AboutUsModel {
  AboutUsEntities toEntity() => AboutUsEntities(
        name: name ?? '',
        description: description ?? '',
        photoLinks: photoLinks ?? const [],
      );
}
