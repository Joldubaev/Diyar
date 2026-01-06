// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_payment_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QrPaymentStatusModel {
  String get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  PaymentStatusEnum get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QrPaymentStatusModelCopyWith<QrPaymentStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrPaymentStatusModelCopyWith<$Res> {
  factory $QrPaymentStatusModelCopyWith(QrPaymentStatusModel value,
          $Res Function(QrPaymentStatusModel) then) =
      _$QrPaymentStatusModelCopyWithImpl<$Res, QrPaymentStatusModel>;
  @useResult
  $Res call({String code, String message, PaymentStatusEnum status});
}

/// @nodoc
class _$QrPaymentStatusModelCopyWithImpl<$Res,
        $Val extends QrPaymentStatusModel>
    implements $QrPaymentStatusModelCopyWith<$Res> {
  _$QrPaymentStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatusEnum,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrPaymentStatusModelImplCopyWith<$Res>
    implements $QrPaymentStatusModelCopyWith<$Res> {
  factory _$$QrPaymentStatusModelImplCopyWith(_$QrPaymentStatusModelImpl value,
          $Res Function(_$QrPaymentStatusModelImpl) then) =
      __$$QrPaymentStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String message, PaymentStatusEnum status});
}

/// @nodoc
class __$$QrPaymentStatusModelImplCopyWithImpl<$Res>
    extends _$QrPaymentStatusModelCopyWithImpl<$Res, _$QrPaymentStatusModelImpl>
    implements _$$QrPaymentStatusModelImplCopyWith<$Res> {
  __$$QrPaymentStatusModelImplCopyWithImpl(_$QrPaymentStatusModelImpl _value,
      $Res Function(_$QrPaymentStatusModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? status = null,
  }) {
    return _then(_$QrPaymentStatusModelImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatusEnum,
    ));
  }
}

/// @nodoc

class _$QrPaymentStatusModelImpl implements _QrPaymentStatusModel {
  const _$QrPaymentStatusModelImpl(
      {required this.code, required this.message, required this.status});

  @override
  final String code;
  @override
  final String message;
  @override
  final PaymentStatusEnum status;

  @override
  String toString() {
    return 'QrPaymentStatusModel(code: $code, message: $message, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrPaymentStatusModelImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QrPaymentStatusModelImplCopyWith<_$QrPaymentStatusModelImpl>
      get copyWith =>
          __$$QrPaymentStatusModelImplCopyWithImpl<_$QrPaymentStatusModelImpl>(
              this, _$identity);
}

abstract class _QrPaymentStatusModel implements QrPaymentStatusModel {
  const factory _QrPaymentStatusModel(
      {required final String code,
      required final String message,
      required final PaymentStatusEnum status}) = _$QrPaymentStatusModelImpl;

  @override
  String get code;
  @override
  String get message;
  @override
  PaymentStatusEnum get status;
  @override
  @JsonKey(ignore: true)
  _$$QrPaymentStatusModelImplCopyWith<_$QrPaymentStatusModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
