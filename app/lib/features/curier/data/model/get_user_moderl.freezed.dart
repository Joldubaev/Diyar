// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_moderl.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserModel _$GetUserModelFromJson(Map<String, dynamic> json) {
  return _GetUserModel.fromJson(json);
}

/// @nodoc
mixin _$GetUserModel {
  String? get id => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  int? get discount => throw _privateConstructorUsedError;

  /// Serializes this GetUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetUserModelCopyWith<GetUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserModelCopyWith<$Res> {
  factory $GetUserModelCopyWith(
          GetUserModel value, $Res Function(GetUserModel) then) =
      _$GetUserModelCopyWithImpl<$Res, GetUserModel>;
  @useResult
  $Res call(
      {String? id,
      String? userName,
      String? email,
      String? phone,
      String? role,
      int? discount});
}

/// @nodoc
class _$GetUserModelCopyWithImpl<$Res, $Val extends GetUserModel>
    implements $GetUserModelCopyWith<$Res> {
  _$GetUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = freezed,
    Object? discount = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetUserModelImplCopyWith<$Res>
    implements $GetUserModelCopyWith<$Res> {
  factory _$$GetUserModelImplCopyWith(
          _$GetUserModelImpl value, $Res Function(_$GetUserModelImpl) then) =
      __$$GetUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? userName,
      String? email,
      String? phone,
      String? role,
      int? discount});
}

/// @nodoc
class __$$GetUserModelImplCopyWithImpl<$Res>
    extends _$GetUserModelCopyWithImpl<$Res, _$GetUserModelImpl>
    implements _$$GetUserModelImplCopyWith<$Res> {
  __$$GetUserModelImplCopyWithImpl(
      _$GetUserModelImpl _value, $Res Function(_$GetUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = freezed,
    Object? discount = freezed,
  }) {
    return _then(_$GetUserModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
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
class _$GetUserModelImpl implements _GetUserModel {
  const _$GetUserModelImpl(
      {this.id,
      this.userName,
      this.email,
      this.phone,
      this.role,
      this.discount});

  factory _$GetUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? userName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? role;
  @override
  final int? discount;

  @override
  String toString() {
    return 'GetUserModel(id: $id, userName: $userName, email: $email, phone: $phone, role: $role, discount: $discount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.discount, discount) ||
                other.discount == discount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userName, email, phone, role, discount);

  /// Create a copy of GetUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserModelImplCopyWith<_$GetUserModelImpl> get copyWith =>
      __$$GetUserModelImplCopyWithImpl<_$GetUserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserModelImplToJson(
      this,
    );
  }
}

abstract class _GetUserModel implements GetUserModel {
  const factory _GetUserModel(
      {final String? id,
      final String? userName,
      final String? email,
      final String? phone,
      final String? role,
      final int? discount}) = _$GetUserModelImpl;

  factory _GetUserModel.fromJson(Map<String, dynamic> json) =
      _$GetUserModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get userName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get role;
  @override
  int? get discount;

  /// Create a copy of GetUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserModelImplCopyWith<_$GetUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
