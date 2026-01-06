// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResetPasswordModel _$ResetPasswordModelFromJson(Map<String, dynamic> json) {
  return _ResetPasswordModel.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordModel {
  String? get phone => throw _privateConstructorUsedError;
  String? get newPassword => throw _privateConstructorUsedError;
  int? get code => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPasswordModelCopyWith<ResetPasswordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordModelCopyWith<$Res> {
  factory $ResetPasswordModelCopyWith(
          ResetPasswordModel value, $Res Function(ResetPasswordModel) then) =
      _$ResetPasswordModelCopyWithImpl<$Res, ResetPasswordModel>;
  @useResult
  $Res call({String? phone, String? newPassword, int? code});
}

/// @nodoc
class _$ResetPasswordModelCopyWithImpl<$Res, $Val extends ResetPasswordModel>
    implements $ResetPasswordModelCopyWith<$Res> {
  _$ResetPasswordModelCopyWithImpl(this._value, this._then);

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
abstract class _$$ResetPasswordModelImplCopyWith<$Res>
    implements $ResetPasswordModelCopyWith<$Res> {
  factory _$$ResetPasswordModelImplCopyWith(_$ResetPasswordModelImpl value,
          $Res Function(_$ResetPasswordModelImpl) then) =
      __$$ResetPasswordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? phone, String? newPassword, int? code});
}

/// @nodoc
class __$$ResetPasswordModelImplCopyWithImpl<$Res>
    extends _$ResetPasswordModelCopyWithImpl<$Res, _$ResetPasswordModelImpl>
    implements _$$ResetPasswordModelImplCopyWith<$Res> {
  __$$ResetPasswordModelImplCopyWithImpl(_$ResetPasswordModelImpl _value,
      $Res Function(_$ResetPasswordModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? newPassword = freezed,
    Object? code = freezed,
  }) {
    return _then(_$ResetPasswordModelImpl(
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
@JsonSerializable()
class _$ResetPasswordModelImpl implements _ResetPasswordModel {
  const _$ResetPasswordModelImpl({this.phone, this.newPassword, this.code});

  factory _$ResetPasswordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordModelImplFromJson(json);

  @override
  final String? phone;
  @override
  final String? newPassword;
  @override
  final int? code;

  @override
  String toString() {
    return 'ResetPasswordModel(phone: $phone, newPassword: $newPassword, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordModelImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, newPassword, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordModelImplCopyWith<_$ResetPasswordModelImpl> get copyWith =>
      __$$ResetPasswordModelImplCopyWithImpl<_$ResetPasswordModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordModelImplToJson(
      this,
    );
  }
}

abstract class _ResetPasswordModel implements ResetPasswordModel {
  const factory _ResetPasswordModel(
      {final String? phone,
      final String? newPassword,
      final int? code}) = _$ResetPasswordModelImpl;

  factory _ResetPasswordModel.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordModelImpl.fromJson;

  @override
  String? get phone;
  @override
  String? get newPassword;
  @override
  int? get code;
  @override
  @JsonKey(ignore: true)
  _$$ResetPasswordModelImplCopyWith<_$ResetPasswordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
