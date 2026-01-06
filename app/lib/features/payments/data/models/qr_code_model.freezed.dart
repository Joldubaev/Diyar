// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_code_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QrCodeModel _$QrCodeModelFromJson(Map<String, dynamic> json) {
  return _QrCodeModel.fromJson(json);
}

/// @nodoc
mixin _$QrCodeModel {
  String? get qrData => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QrCodeModelCopyWith<QrCodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrCodeModelCopyWith<$Res> {
  factory $QrCodeModelCopyWith(
          QrCodeModel value, $Res Function(QrCodeModel) then) =
      _$QrCodeModelCopyWithImpl<$Res, QrCodeModel>;
  @useResult
  $Res call({String? qrData, String? transactionId});
}

/// @nodoc
class _$QrCodeModelCopyWithImpl<$Res, $Val extends QrCodeModel>
    implements $QrCodeModelCopyWith<$Res> {
  _$QrCodeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrData = freezed,
    Object? transactionId = freezed,
  }) {
    return _then(_value.copyWith(
      qrData: freezed == qrData
          ? _value.qrData
          : qrData // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrCodeModelImplCopyWith<$Res>
    implements $QrCodeModelCopyWith<$Res> {
  factory _$$QrCodeModelImplCopyWith(
          _$QrCodeModelImpl value, $Res Function(_$QrCodeModelImpl) then) =
      __$$QrCodeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? qrData, String? transactionId});
}

/// @nodoc
class __$$QrCodeModelImplCopyWithImpl<$Res>
    extends _$QrCodeModelCopyWithImpl<$Res, _$QrCodeModelImpl>
    implements _$$QrCodeModelImplCopyWith<$Res> {
  __$$QrCodeModelImplCopyWithImpl(
      _$QrCodeModelImpl _value, $Res Function(_$QrCodeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrData = freezed,
    Object? transactionId = freezed,
  }) {
    return _then(_$QrCodeModelImpl(
      qrData: freezed == qrData
          ? _value.qrData
          : qrData // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QrCodeModelImpl implements _QrCodeModel {
  const _$QrCodeModelImpl({this.qrData, this.transactionId});

  factory _$QrCodeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QrCodeModelImplFromJson(json);

  @override
  final String? qrData;
  @override
  final String? transactionId;

  @override
  String toString() {
    return 'QrCodeModel(qrData: $qrData, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrCodeModelImpl &&
            (identical(other.qrData, qrData) || other.qrData == qrData) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, qrData, transactionId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QrCodeModelImplCopyWith<_$QrCodeModelImpl> get copyWith =>
      __$$QrCodeModelImplCopyWithImpl<_$QrCodeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QrCodeModelImplToJson(
      this,
    );
  }
}

abstract class _QrCodeModel implements QrCodeModel {
  const factory _QrCodeModel(
      {final String? qrData, final String? transactionId}) = _$QrCodeModelImpl;

  factory _QrCodeModel.fromJson(Map<String, dynamic> json) =
      _$QrCodeModelImpl.fromJson;

  @override
  String? get qrData;
  @override
  String? get transactionId;
  @override
  @JsonKey(ignore: true)
  _$$QrCodeModelImplCopyWith<_$QrCodeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
