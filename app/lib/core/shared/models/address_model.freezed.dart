// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return _AddressModel.fromJson(json);
}

/// @nodoc
mixin _$AddressModel {
  String get address => throw _privateConstructorUsedError;
  String get houseNumber => throw _privateConstructorUsedError;
  String? get entrance => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError;
  String? get intercom => throw _privateConstructorUsedError;
  String? get kvOffice => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressModelCopyWith<AddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
          AddressModel value, $Res Function(AddressModel) then) =
      _$AddressModelCopyWithImpl<$Res, AddressModel>;
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
class _$AddressModelCopyWithImpl<$Res, $Val extends AddressModel>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
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
abstract class _$$AddressModelImplCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$$AddressModelImplCopyWith(
          _$AddressModelImpl value, $Res Function(_$AddressModelImpl) then) =
      __$$AddressModelImplCopyWithImpl<$Res>;
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
class __$$AddressModelImplCopyWithImpl<$Res>
    extends _$AddressModelCopyWithImpl<$Res, _$AddressModelImpl>
    implements _$$AddressModelImplCopyWith<$Res> {
  __$$AddressModelImplCopyWithImpl(
      _$AddressModelImpl _value, $Res Function(_$AddressModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
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
    return _then(_$AddressModelImpl(
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
@JsonSerializable()
class _$AddressModelImpl implements _AddressModel {
  const _$AddressModelImpl(
      {required this.address,
      required this.houseNumber,
      this.entrance,
      this.floor,
      this.intercom,
      this.kvOffice,
      this.comment,
      this.region});

  factory _$AddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressModelImplFromJson(json);

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
    return 'AddressModel(address: $address, houseNumber: $houseNumber, entrance: $entrance, floor: $floor, intercom: $intercom, kvOffice: $kvOffice, comment: $comment, region: $region)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address, houseNumber, entrance,
      floor, intercom, kvOffice, comment, region);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      __$$AddressModelImplCopyWithImpl<_$AddressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressModelImplToJson(
      this,
    );
  }
}

abstract class _AddressModel implements AddressModel {
  const factory _AddressModel(
      {required final String address,
      required final String houseNumber,
      final String? entrance,
      final String? floor,
      final String? intercom,
      final String? kvOffice,
      final String? comment,
      final String? region}) = _$AddressModelImpl;

  factory _AddressModel.fromJson(Map<String, dynamic> json) =
      _$AddressModelImpl.fromJson;

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

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
