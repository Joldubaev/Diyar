// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ResetPasswordEntity {
  String? get phone => throw _privateConstructorUsedError;
  String? get newPassword => throw _privateConstructorUsedError;
  int? get code => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResetPasswordEntityCopyWith<ResetPasswordEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordEntityCopyWith<$Res> {
  factory $ResetPasswordEntityCopyWith(
          ResetPasswordEntity value, $Res Function(ResetPasswordEntity) then) =
      _$ResetPasswordEntityCopyWithImpl<$Res, ResetPasswordEntity>;
  @useResult
  $Res call({String? phone, String? newPassword, int? code});
}

/// @nodoc
class _$ResetPasswordEntityCopyWithImpl<$Res, $Val extends ResetPasswordEntity>
    implements $ResetPasswordEntityCopyWith<$Res> {
  _$ResetPasswordEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? newPassword = freezed,
    Object? code = freezed,
  }) {
    return _then(_value.copyWith(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      newPassword: freezed == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPasswordEntityImplCopyWith<$Res>
    implements $ResetPasswordEntityCopyWith<$Res> {
  factory _$$ResetPasswordEntityImplCopyWith(_$ResetPasswordEntityImpl value,
          $Res Function(_$ResetPasswordEntityImpl) then) =
      __$$ResetPasswordEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? phone, String? newPassword, int? code});
}

/// @nodoc
class __$$ResetPasswordEntityImplCopyWithImpl<$Res>
    extends _$ResetPasswordEntityCopyWithImpl<$Res, _$ResetPasswordEntityImpl>
    implements _$$ResetPasswordEntityImplCopyWith<$Res> {
  __$$ResetPasswordEntityImplCopyWithImpl(_$ResetPasswordEntityImpl _value,
      $Res Function(_$ResetPasswordEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? newPassword = freezed,
    Object? code = freezed,
  }) {
    return _then(_$ResetPasswordEntityImpl(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      newPassword: freezed == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ResetPasswordEntityImpl implements _ResetPasswordEntity {
  const _$ResetPasswordEntityImpl({this.phone, this.newPassword, this.code});

  @override
  final String? phone;
  @override
  final String? newPassword;
  @override
  final int? code;

  @override
  String toString() {
    return 'ResetPasswordEntity(phone: $phone, newPassword: $newPassword, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordEntityImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phone, newPassword, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordEntityImplCopyWith<_$ResetPasswordEntityImpl> get copyWith =>
      __$$ResetPasswordEntityImplCopyWithImpl<_$ResetPasswordEntityImpl>(
          this, _$identity);
}

abstract class _ResetPasswordEntity implements ResetPasswordEntity {
  const factory _ResetPasswordEntity(
      {final String? phone,
      final String? newPassword,
      final int? code}) = _$ResetPasswordEntityImpl;

  @override
  String? get phone;
  @override
  String? get newPassword;
  @override
  int? get code;
  @override
  @JsonKey(ignore: true)
  _$$ResetPasswordEntityImplCopyWith<_$ResetPasswordEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
