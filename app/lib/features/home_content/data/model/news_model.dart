import 'package:diyar/features/home_content/domain/entities/news_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
class NewsModel with _$NewsModel {
  const factory NewsModel({
    String? id,
    String? name,
    String? description,
    String? photoLink,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  factory NewsModel.fromEntity(NewsEntity entity) => NewsModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        photoLink: entity.photoLink,
      );
}

extension NewsModelX on NewsModel {
  NewsEntity toEntity() => NewsEntity(
        id: id,
        name: name,
        description: description,
        photoLink: photoLink,
      );
}
