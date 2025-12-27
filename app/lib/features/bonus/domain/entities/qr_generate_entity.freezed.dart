// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_generate_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QrGenerateEntity {
  String? get qrData => throw _privateConstructorUsedError; // URL для QR кода
  String? get expiresAt => throw _privateConstructorUsedError;

  /// Create a copy of QrGenerateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrGenerateEntityCopyWith<QrGenerateEntity> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrGenerateEntityCopyWith<$Res> {
  factory $QrGenerateEntityCopyWith(QrGenerateEntity value, $Res Function(QrGenerateEntity) then) =
      _$QrGenerateEntityCopyWithImpl<$Res, QrGenerateEntity>;
  @useResult
  $Res call({String? qrData, String? expiresAt});
}

/// @nodoc
class _$QrGenerateEntityCopyWithImpl<$Res, $Val extends QrGenerateEntity> implements $QrGenerateEntityCopyWith<$Res> {
  _$QrGenerateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrGenerateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrData = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      qrData: freezed == qrData
          ? _value.qrData
          : qrData // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrGenerateEntityImplCopyWith<$Res> implements $QrGenerateEntityCopyWith<$Res> {
  factory _$$QrGenerateEntityImplCopyWith(_$QrGenerateEntityImpl value, $Res Function(_$QrGenerateEntityImpl) then) =
      __$$QrGenerateEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? qrData, String? expiresAt});
}

/// @nodoc
class __$$QrGenerateEntityImplCopyWithImpl<$Res> extends _$QrGenerateEntityCopyWithImpl<$Res, _$QrGenerateEntityImpl>
    implements _$$QrGenerateEntityImplCopyWith<$Res> {
  __$$QrGenerateEntityImplCopyWithImpl(_$QrGenerateEntityImpl _value, $Res Function(_$QrGenerateEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of QrGenerateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrData = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$QrGenerateEntityImpl(
      qrData: freezed == qrData
          ? _value.qrData
          : qrData // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$QrGenerateEntityImpl extends QrGenerateEntity implements _QrGenerateEntity {
  const _$QrGenerateEntityImpl({this.qrData, this.expiresAt}) : super._();

  @override
  final String? qrData;
// URL для QR кода
  @override
  final String? expiresAt;

  @override
  String toString() {
    return 'QrGenerateEntity(qrData: $qrData, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrGenerateEntityImpl &&
            (identical(other.qrData, qrData) || other.qrData == qrData) &&
            (identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, qrData, expiresAt);

  /// Create a copy of QrGenerateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrGenerateEntityImplCopyWith<_$QrGenerateEntityImpl> get copyWith =>
      __$$QrGenerateEntityImplCopyWithImpl<_$QrGenerateEntityImpl>(this, _$identity);
}

abstract class _QrGenerateEntity implements QrGenerateEntity {
  const factory _QrGenerateEntity({final String? qrData, final String? expiresAt}) = _$QrGenerateEntityImpl;

  @override
  String? get qrData; // URL для QR кода
  @override
  String? get expiresAt;

  /// Create a copy of QrGenerateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrGenerateEntityImplCopyWith<_$QrGenerateEntityImpl> get copyWith => throw _privateConstructorUsedError;
}
