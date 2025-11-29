// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_us_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AboutUsModelImpl _$$AboutUsModelImplFromJson(Map<String, dynamic> json) =>
    _$AboutUsModelImpl(
      name: json['name'] as String?,
      description: json['description'] as String?,
      photoLinks: (json['photoLinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AboutUsModelImplToJson(_$AboutUsModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'photoLinks': instance.photoLinks,
    };
