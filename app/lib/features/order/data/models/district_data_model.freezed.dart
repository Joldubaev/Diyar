// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'district_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DistrictDataModel _$DistrictDataModelFromJson(Map<String, dynamic> json) {
  return _DistrictDataModel.fromJson(json);
}

/// @nodoc
mixin _$DistrictDataModel {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  dynamic get price => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DistrictDataModelCopyWith<DistrictDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistrictDataModelCopyWith<$Res> {
  factory $DistrictDataModelCopyWith(
          DistrictDataModel value, $Res Function(DistrictDataModel) then) =
      _$DistrictDataModelCopyWithImpl<$Res, DistrictDataModel>;
  @useResult
  $Res call({String? id, String? name, dynamic price});
}

/// @nodoc
class _$DistrictDataModelCopyWithImpl<$Res, $Val extends DistrictDataModel>
    implements $DistrictDataModelCopyWith<$Res> {
  _$DistrictDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? price = freezed,
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
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DistrictDataModelImplCopyWith<$Res>
    implements $DistrictDataModelCopyWith<$Res> {
  factory _$$DistrictDataModelImplCopyWith(_$DistrictDataModelImpl value,
          $Res Function(_$DistrictDataModelImpl) then) =
      __$$DistrictDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? name, dynamic price});
}

/// @nodoc
class __$$DistrictDataModelImplCopyWithImpl<$Res>
    extends _$DistrictDataModelCopyWithImpl<$Res, _$DistrictDataModelImpl>
    implements _$$DistrictDataModelImplCopyWith<$Res> {
  __$$DistrictDataModelImplCopyWithImpl(_$DistrictDataModelImpl _value,
      $Res Function(_$DistrictDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? price = freezed,
  }) {
    return _then(_$DistrictDataModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DistrictDataModelImpl implements _DistrictDataModel {
  const _$DistrictDataModelImpl({this.id, this.name, this.price});

  factory _$DistrictDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DistrictDataModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final dynamic price;

  @override
  String toString() {
    return 'DistrictDataModel(id: $id, name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DistrictDataModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.price, price));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(price));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DistrictDataModelImplCopyWith<_$DistrictDataModelImpl> get copyWith =>
      __$$DistrictDataModelImplCopyWithImpl<_$DistrictDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DistrictDataModelImplToJson(
      this,
    );
  }
}

abstract class _DistrictDataModel implements DistrictDataModel {
  const factory _DistrictDataModel(
      {final String? id,
      final String? name,
      final dynamic price}) = _$DistrictDataModelImpl;

  factory _DistrictDataModel.fromJson(Map<String, dynamic> json) =
      _$DistrictDataModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  dynamic get price;
  @override
  @JsonKey(ignore: true)
  _$$DistrictDataModelImplCopyWith<_$DistrictDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
