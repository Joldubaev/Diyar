// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentsModel _$PaymentsModelFromJson(Map<String, dynamic> json) {
  return _PaymentsModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentsModel {
  String? get orderNumber => throw _privateConstructorUsedError;
  String? get user => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get pinCode => throw _privateConstructorUsedError;
  String? get otp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentsModelCopyWith<PaymentsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentsModelCopyWith<$Res> {
  factory $PaymentsModelCopyWith(
          PaymentsModel value, $Res Function(PaymentsModel) then) =
      _$PaymentsModelCopyWithImpl<$Res, PaymentsModel>;
  @useResult
  $Res call(
      {String? orderNumber,
      String? user,
      double? amount,
      String? pinCode,
      String? otp});
}

/// @nodoc
class _$PaymentsModelCopyWithImpl<$Res, $Val extends PaymentsModel>
    implements $PaymentsModelCopyWith<$Res> {
  _$PaymentsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNumber = freezed,
    Object? user = freezed,
    Object? amount = freezed,
    Object? pinCode = freezed,
    Object? otp = freezed,
  }) {
    return _then(_value.copyWith(
      orderNumber: freezed == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      pinCode: freezed == pinCode
          ? _value.pinCode
          : pinCode // ignore: cast_nullable_to_non_nullable
              as String?,
      otp: freezed == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentsModelImplCopyWith<$Res>
    implements $PaymentsModelCopyWith<$Res> {
  factory _$$PaymentsModelImplCopyWith(
          _$PaymentsModelImpl value, $Res Function(_$PaymentsModelImpl) then) =
      __$$PaymentsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? orderNumber,
      String? user,
      double? amount,
      String? pinCode,
      String? otp});
}

/// @nodoc
class __$$PaymentsModelImplCopyWithImpl<$Res>
    extends _$PaymentsModelCopyWithImpl<$Res, _$PaymentsModelImpl>
    implements _$$PaymentsModelImplCopyWith<$Res> {
  __$$PaymentsModelImplCopyWithImpl(
      _$PaymentsModelImpl _value, $Res Function(_$PaymentsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNumber = freezed,
    Object? user = freezed,
    Object? amount = freezed,
    Object? pinCode = freezed,
    Object? otp = freezed,
  }) {
    return _then(_$PaymentsModelImpl(
      orderNumber: freezed == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      pinCode: freezed == pinCode
          ? _value.pinCode
          : pinCode // ignore: cast_nullable_to_non_nullable
              as String?,
      otp: freezed == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentsModelImpl implements _PaymentsModel {
  const _$PaymentsModelImpl(
      {this.orderNumber, this.user, this.amount, this.pinCode, this.otp});

  factory _$PaymentsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentsModelImplFromJson(json);

  @override
  final String? orderNumber;
  @override
  final String? user;
  @override
  final double? amount;
  @override
  final String? pinCode;
  @override
  final String? otp;

  @override
  String toString() {
    return 'PaymentsModel(orderNumber: $orderNumber, user: $user, amount: $amount, pinCode: $pinCode, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentsModelImpl &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.pinCode, pinCode) || other.pinCode == pinCode) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderNumber, user, amount, pinCode, otp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentsModelImplCopyWith<_$PaymentsModelImpl> get copyWith =>
      __$$PaymentsModelImplCopyWithImpl<_$PaymentsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentsModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentsModel implements PaymentsModel {
  const factory _PaymentsModel(
      {final String? orderNumber,
      final String? user,
      final double? amount,
      final String? pinCode,
      final String? otp}) = _$PaymentsModelImpl;

  factory _PaymentsModel.fromJson(Map<String, dynamic> json) =
      _$PaymentsModelImpl.fromJson;

  @override
  String? get orderNumber;
  @override
  String? get user;
  @override
  double? get amount;
  @override
  String? get pinCode;
  @override
  String? get otp;
  @override
  @JsonKey(ignore: true)
  _$$PaymentsModelImplCopyWith<_$PaymentsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
