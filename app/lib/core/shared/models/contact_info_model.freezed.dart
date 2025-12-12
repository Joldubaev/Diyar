// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactInfoModel _$ContactInfoModelFromJson(Map<String, dynamic> json) {
  return _ContactInfoModel.fromJson(json);
}

/// @nodoc
mixin _$ContactInfoModel {
  String get userName => throw _privateConstructorUsedError;
  String get userPhone => throw _privateConstructorUsedError;

  /// Serializes this ContactInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactInfoModelCopyWith<ContactInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoModelCopyWith<$Res> {
  factory $ContactInfoModelCopyWith(
          ContactInfoModel value, $Res Function(ContactInfoModel) then) =
      _$ContactInfoModelCopyWithImpl<$Res, ContactInfoModel>;
  @useResult
  $Res call({String userName, String userPhone});
}

/// @nodoc
class _$ContactInfoModelCopyWithImpl<$Res, $Val extends ContactInfoModel>
    implements $ContactInfoModelCopyWith<$Res> {
  _$ContactInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? userPhone = null,
  }) {
    return _then(_value.copyWith(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: null == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactInfoModelImplCopyWith<$Res>
    implements $ContactInfoModelCopyWith<$Res> {
  factory _$$ContactInfoModelImplCopyWith(_$ContactInfoModelImpl value,
          $Res Function(_$ContactInfoModelImpl) then) =
      __$$ContactInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userName, String userPhone});
}

/// @nodoc
class __$$ContactInfoModelImplCopyWithImpl<$Res>
    extends _$ContactInfoModelCopyWithImpl<$Res, _$ContactInfoModelImpl>
    implements _$$ContactInfoModelImplCopyWith<$Res> {
  __$$ContactInfoModelImplCopyWithImpl(_$ContactInfoModelImpl _value,
      $Res Function(_$ContactInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? userPhone = null,
  }) {
    return _then(_$ContactInfoModelImpl(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: null == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactInfoModelImpl implements _ContactInfoModel {
  const _$ContactInfoModelImpl(
      {required this.userName, required this.userPhone});

  factory _$ContactInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoModelImplFromJson(json);

  @override
  final String userName;
  @override
  final String userPhone;

  @override
  String toString() {
    return 'ContactInfoModel(userName: $userName, userPhone: $userPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoModelImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userName, userPhone);

  /// Create a copy of ContactInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoModelImplCopyWith<_$ContactInfoModelImpl> get copyWith =>
      __$$ContactInfoModelImplCopyWithImpl<_$ContactInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoModelImplToJson(
      this,
    );
  }
}

abstract class _ContactInfoModel implements ContactInfoModel {
  const factory _ContactInfoModel(
      {required final String userName,
      required final String userPhone}) = _$ContactInfoModelImpl;

  factory _ContactInfoModel.fromJson(Map<String, dynamic> json) =
      _$ContactInfoModelImpl.fromJson;

  @override
  String get userName;
  @override
  String get userPhone;

  /// Create a copy of ContactInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactInfoModelImplCopyWith<_$ContactInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
