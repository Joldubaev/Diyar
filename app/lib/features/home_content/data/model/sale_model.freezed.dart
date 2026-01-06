// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) {
  return _SaleModel.fromJson(json);
}

/// @nodoc
mixin _$SaleModel {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get photoLink => throw _privateConstructorUsedError;
  int? get discount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SaleModelCopyWith<SaleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleModelCopyWith<$Res> {
  factory $SaleModelCopyWith(SaleModel value, $Res Function(SaleModel) then) =
      _$SaleModelCopyWithImpl<$Res, SaleModel>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      String? photoLink,
      int? discount});
}

/// @nodoc
class _$SaleModelCopyWithImpl<$Res, $Val extends SaleModel>
    implements $SaleModelCopyWith<$Res> {
  _$SaleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? photoLink = freezed,
    Object? discount = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      photoLink: freezed == photoLink
          ? _value.photoLink
          : photoLink // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaleModelImplCopyWith<$Res>
    implements $SaleModelCopyWith<$Res> {
  factory _$$SaleModelImplCopyWith(
          _$SaleModelImpl value, $Res Function(_$SaleModelImpl) then) =
      __$$SaleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      String? photoLink,
      int? discount});
}

/// @nodoc
class __$$SaleModelImplCopyWithImpl<$Res>
    extends _$SaleModelCopyWithImpl<$Res, _$SaleModelImpl>
    implements _$$SaleModelImplCopyWith<$Res> {
  __$$SaleModelImplCopyWithImpl(
      _$SaleModelImpl _value, $Res Function(_$SaleModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? photoLink = freezed,
    Object? discount = freezed,
  }) {
    return _then(_$SaleModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      photoLink: freezed == photoLink
          ? _value.photoLink
          : photoLink // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleModelImpl implements _SaleModel {
  const _$SaleModelImpl(
      {this.id, this.name, this.description, this.photoLink, this.discount});

  factory _$SaleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? photoLink;
  @override
  final int? discount;

  @override
  String toString() {
    return 'SaleModel(id: $id, name: $name, description: $description, photoLink: $photoLink, discount: $discount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.photoLink, photoLink) ||
                other.photoLink == photoLink) &&
            (identical(other.discount, discount) ||
                other.discount == discount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, description, photoLink, discount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleModelImplCopyWith<_$SaleModelImpl> get copyWith =>
      __$$SaleModelImplCopyWithImpl<_$SaleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleModelImplToJson(
      this,
    );
  }
}

abstract class _SaleModel implements SaleModel {
  const factory _SaleModel(
      {final String? id,
      final String? name,
      final String? description,
      final String? photoLink,
      final int? discount}) = _$SaleModelImpl;

  factory _SaleModel.fromJson(Map<String, dynamic> json) =
      _$SaleModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get description;
  @override
  String? get photoLink;
  @override
  int? get discount;
  @override
  @JsonKey(ignore: true)
  _$$SaleModelImplCopyWith<_$SaleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
