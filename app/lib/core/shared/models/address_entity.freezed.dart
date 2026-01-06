// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddressEntity {
  String get address => throw _privateConstructorUsedError;
  String get houseNumber => throw _privateConstructorUsedError;
  String? get entrance => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError;
  String? get intercom => throw _privateConstructorUsedError;
  String? get kvOffice => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddressEntityCopyWith<AddressEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressEntityCopyWith<$Res> {
  factory $AddressEntityCopyWith(
          AddressEntity value, $Res Function(AddressEntity) then) =
      _$AddressEntityCopyWithImpl<$Res, AddressEntity>;
  @useResult
  $Res call(
      {String address,
      String houseNumber,
      String? entrance,
      String? floor,
      String? intercom,
      String? kvOffice,
      String? comment,
      String? region});
}

/// @nodoc
class _$AddressEntityCopyWithImpl<$Res, $Val extends AddressEntity>
    implements $AddressEntityCopyWith<$Res> {
  _$AddressEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? houseNumber = null,
    Object? entrance = freezed,
    Object? floor = freezed,
    Object? intercom = freezed,
    Object? kvOffice = freezed,
    Object? comment = freezed,
    Object? region = freezed,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      houseNumber: null == houseNumber
          ? _value.houseNumber
          : houseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      entrance: freezed == entrance
          ? _value.entrance
          : entrance // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      intercom: freezed == intercom
          ? _value.intercom
          : intercom // ignore: cast_nullable_to_non_nullable
              as String?,
      kvOffice: freezed == kvOffice
          ? _value.kvOffice
          : kvOffice // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressEntityImplCopyWith<$Res>
    implements $AddressEntityCopyWith<$Res> {
  factory _$$AddressEntityImplCopyWith(
          _$AddressEntityImpl value, $Res Function(_$AddressEntityImpl) then) =
      __$$AddressEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String address,
      String houseNumber,
      String? entrance,
      String? floor,
      String? intercom,
      String? kvOffice,
      String? comment,
      String? region});
}

/// @nodoc
class __$$AddressEntityImplCopyWithImpl<$Res>
    extends _$AddressEntityCopyWithImpl<$Res, _$AddressEntityImpl>
    implements _$$AddressEntityImplCopyWith<$Res> {
  __$$AddressEntityImplCopyWithImpl(
      _$AddressEntityImpl _value, $Res Function(_$AddressEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? houseNumber = null,
    Object? entrance = freezed,
    Object? floor = freezed,
    Object? intercom = freezed,
    Object? kvOffice = freezed,
    Object? comment = freezed,
    Object? region = freezed,
  }) {
    return _then(_$AddressEntityImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      houseNumber: null == houseNumber
          ? _value.houseNumber
          : houseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      entrance: freezed == entrance
          ? _value.entrance
          : entrance // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      intercom: freezed == intercom
          ? _value.intercom
          : intercom // ignore: cast_nullable_to_non_nullable
              as String?,
      kvOffice: freezed == kvOffice
          ? _value.kvOffice
          : kvOffice // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AddressEntityImpl implements _AddressEntity {
  const _$AddressEntityImpl(
      {required this.address,
      required this.houseNumber,
      this.entrance,
      this.floor,
      this.intercom,
      this.kvOffice,
      this.comment,
      this.region});

  @override
  final String address;
  @override
  final String houseNumber;
  @override
  final String? entrance;
  @override
  final String? floor;
  @override
  final String? intercom;
  @override
  final String? kvOffice;
  @override
  final String? comment;
  @override
  final String? region;

  @override
  String toString() {
    return 'AddressEntity(address: $address, houseNumber: $houseNumber, entrance: $entrance, floor: $floor, intercom: $intercom, kvOffice: $kvOffice, comment: $comment, region: $region)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressEntityImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.houseNumber, houseNumber) ||
                other.houseNumber == houseNumber) &&
            (identical(other.entrance, entrance) ||
                other.entrance == entrance) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.intercom, intercom) ||
                other.intercom == intercom) &&
            (identical(other.kvOffice, kvOffice) ||
                other.kvOffice == kvOffice) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.region, region) || other.region == region));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address, houseNumber, entrance,
      floor, intercom, kvOffice, comment, region);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressEntityImplCopyWith<_$AddressEntityImpl> get copyWith =>
      __$$AddressEntityImplCopyWithImpl<_$AddressEntityImpl>(this, _$identity);
}

abstract class _AddressEntity implements AddressEntity {
  const factory _AddressEntity(
      {required final String address,
      required final String houseNumber,
      final String? entrance,
      final String? floor,
      final String? intercom,
      final String? kvOffice,
      final String? comment,
      final String? region}) = _$AddressEntityImpl;

  @override
  String get address;
  @override
  String get houseNumber;
  @override
  String? get entrance;
  @override
  String? get floor;
  @override
  String? get intercom;
  @override
  String? get kvOffice;
  @override
  String? get comment;
  @override
  String? get region;
  @override
  @JsonKey(ignore: true)
  _$$AddressEntityImplCopyWith<_$AddressEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
