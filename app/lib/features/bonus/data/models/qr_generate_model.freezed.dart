// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_generate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QrGenerateModel _$QrGenerateModelFromJson(Map<String, dynamic> json) {
  return _QrGenerateModel.fromJson(json);
}

/// @nodoc
mixin _$QrGenerateModel {
  String? get qrData => throw _privateConstructorUsedError;
  String? get expiresAtString => throw _privateConstructorUsedError;

  /// Serializes this QrGenerateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QrGenerateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrGenerateModelCopyWith<QrGenerateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrGenerateModelCopyWith<$Res> {
  factory $QrGenerateModelCopyWith(
          QrGenerateModel value, $Res Function(QrGenerateModel) then) =
      _$QrGenerateModelCopyWithImpl<$Res, QrGenerateModel>;
  @useResult
  $Res call({String? qrData, String? expiresAtString});
}

/// @nodoc
class _$QrGenerateModelCopyWithImpl<$Res, $Val extends QrGenerateModel>
    implements $QrGenerateModelCopyWith<$Res> {
  _$QrGenerateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrGenerateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrData = freezed,
    Object? expiresAtString = freezed,
  }) {
    return _then(_value.copyWith(
      qrData: freezed == qrData
          ? _value.qrData
          : qrData // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAtString: freezed == expiresAtString
          ? _value.expiresAtString
          : expiresAtString // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrGenerateModelImplCopyWith<$Res>
    implements $QrGenerateModelCopyWith<$Res> {
  factory _$$QrGenerateModelImplCopyWith(_$QrGenerateModelImpl value,
          $Res Function(_$QrGenerateModelImpl) then) =
      __$$QrGenerateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? qrData, String? expiresAtString});
}

/// @nodoc
class __$$QrGenerateModelImplCopyWithImpl<$Res>
    extends _$QrGenerateModelCopyWithImpl<$Res, _$QrGenerateModelImpl>
    implements _$$QrGenerateModelImplCopyWith<$Res> {
  __$$QrGenerateModelImplCopyWithImpl(
      _$QrGenerateModelImpl _value, $Res Function(_$QrGenerateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QrGenerateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrData = freezed,
    Object? expiresAtString = freezed,
  }) {
    return _then(_$QrGenerateModelImpl(
      qrData: freezed == qrData
          ? _value.qrData
          : qrData // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAtString: freezed == expiresAtString
          ? _value.expiresAtString
          : expiresAtString // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QrGenerateModelImpl implements _QrGenerateModel {
  const _$QrGenerateModelImpl({this.qrData, this.expiresAtString});

  factory _$QrGenerateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QrGenerateModelImplFromJson(json);

  @override
  final String? qrData;
  @override
  final String? expiresAtString;

  @override
  String toString() {
    return 'QrGenerateModel(qrData: $qrData, expiresAtString: $expiresAtString)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrGenerateModelImpl &&
            (identical(other.qrData, qrData) || other.qrData == qrData) &&
            (identical(other.expiresAtString, expiresAtString) ||
                other.expiresAtString == expiresAtString));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, qrData, expiresAtString);

  /// Create a copy of QrGenerateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrGenerateModelImplCopyWith<_$QrGenerateModelImpl> get copyWith =>
      __$$QrGenerateModelImplCopyWithImpl<_$QrGenerateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QrGenerateModelImplToJson(
      this,
    );
  }
}

abstract class _QrGenerateModel implements QrGenerateModel {
  const factory _QrGenerateModel(
      {final String? qrData,
      final String? expiresAtString}) = _$QrGenerateModelImpl;

  factory _QrGenerateModel.fromJson(Map<String, dynamic> json) =
      _$QrGenerateModelImpl.fromJson;

  @override
  String? get qrData;
  @override
  String? get expiresAtString;

  /// Create a copy of QrGenerateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrGenerateModelImplCopyWith<_$QrGenerateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
