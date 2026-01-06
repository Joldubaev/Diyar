// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'about_us_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AboutUsModel _$AboutUsModelFromJson(Map<String, dynamic> json) {
  return _AboutUsModel.fromJson(json);
}

/// @nodoc
mixin _$AboutUsModel {
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get photoLinks => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AboutUsModelCopyWith<AboutUsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AboutUsModelCopyWith<$Res> {
  factory $AboutUsModelCopyWith(
          AboutUsModel value, $Res Function(AboutUsModel) then) =
      _$AboutUsModelCopyWithImpl<$Res, AboutUsModel>;
  @useResult
  $Res call({String? name, String? description, List<String>? photoLinks});
}

/// @nodoc
class _$AboutUsModelCopyWithImpl<$Res, $Val extends AboutUsModel>
    implements $AboutUsModelCopyWith<$Res> {
  _$AboutUsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? photoLinks = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      photoLinks: freezed == photoLinks
          ? _value.photoLinks
          : photoLinks // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AboutUsModelImplCopyWith<$Res>
    implements $AboutUsModelCopyWith<$Res> {
  factory _$$AboutUsModelImplCopyWith(
          _$AboutUsModelImpl value, $Res Function(_$AboutUsModelImpl) then) =
      __$$AboutUsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? description, List<String>? photoLinks});
}

/// @nodoc
class __$$AboutUsModelImplCopyWithImpl<$Res>
    extends _$AboutUsModelCopyWithImpl<$Res, _$AboutUsModelImpl>
    implements _$$AboutUsModelImplCopyWith<$Res> {
  __$$AboutUsModelImplCopyWithImpl(
      _$AboutUsModelImpl _value, $Res Function(_$AboutUsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? photoLinks = freezed,
  }) {
    return _then(_$AboutUsModelImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      photoLinks: freezed == photoLinks
          ? _value._photoLinks
          : photoLinks // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AboutUsModelImpl implements _AboutUsModel {
  const _$AboutUsModelImpl(
      {this.name, this.description, final List<String>? photoLinks})
      : _photoLinks = photoLinks;

  factory _$AboutUsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AboutUsModelImplFromJson(json);

  @override
  final String? name;
  @override
  final String? description;
  final List<String>? _photoLinks;
  @override
  List<String>? get photoLinks {
    final value = _photoLinks;
    if (value == null) return null;
    if (_photoLinks is EqualUnmodifiableListView) return _photoLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AboutUsModel(name: $name, description: $description, photoLinks: $photoLinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AboutUsModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._photoLinks, _photoLinks));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description,
      const DeepCollectionEquality().hash(_photoLinks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AboutUsModelImplCopyWith<_$AboutUsModelImpl> get copyWith =>
      __$$AboutUsModelImplCopyWithImpl<_$AboutUsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AboutUsModelImplToJson(
      this,
    );
  }
}

abstract class _AboutUsModel implements AboutUsModel {
  const factory _AboutUsModel(
      {final String? name,
      final String? description,
      final List<String>? photoLinks}) = _$AboutUsModelImpl;

  factory _AboutUsModel.fromJson(Map<String, dynamic> json) =
      _$AboutUsModelImpl.fromJson;

  @override
  String? get name;
  @override
  String? get description;
  @override
  List<String>? get photoLinks;
  @override
  @JsonKey(ignore: true)
  _$$AboutUsModelImplCopyWith<_$AboutUsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
