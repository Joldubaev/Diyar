// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mbank_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MbankModel {
  int? get amount => throw _privateConstructorUsedError;
  String? get quid => throw _privateConstructorUsedError;
  DateTime? get dateTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MbankModelCopyWith<MbankModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MbankModelCopyWith<$Res> {
  factory $MbankModelCopyWith(
          MbankModel value, $Res Function(MbankModel) then) =
      _$MbankModelCopyWithImpl<$Res, MbankModel>;
  @useResult
  $Res call({int? amount, String? quid, DateTime? dateTime});
}

/// @nodoc
class _$MbankModelCopyWithImpl<$Res, $Val extends MbankModel>
    implements $MbankModelCopyWith<$Res> {
  _$MbankModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? quid = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_value.copyWith(
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      quid: freezed == quid
          ? _value.quid
          : quid // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MbankModelImplCopyWith<$Res>
    implements $MbankModelCopyWith<$Res> {
  factory _$$MbankModelImplCopyWith(
          _$MbankModelImpl value, $Res Function(_$MbankModelImpl) then) =
      __$$MbankModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? amount, String? quid, DateTime? dateTime});
}

/// @nodoc
class __$$MbankModelImplCopyWithImpl<$Res>
    extends _$MbankModelCopyWithImpl<$Res, _$MbankModelImpl>
    implements _$$MbankModelImplCopyWith<$Res> {
  __$$MbankModelImplCopyWithImpl(
      _$MbankModelImpl _value, $Res Function(_$MbankModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? quid = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_$MbankModelImpl(
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      quid: freezed == quid
          ? _value.quid
          : quid // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$MbankModelImpl implements _MbankModel {
  const _$MbankModelImpl({this.amount, this.quid, this.dateTime});

  @override
  final int? amount;
  @override
  final String? quid;
  @override
  final DateTime? dateTime;

  @override
  String toString() {
    return 'MbankModel(amount: $amount, quid: $quid, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MbankModelImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.quid, quid) || other.quid == quid) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, quid, dateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MbankModelImplCopyWith<_$MbankModelImpl> get copyWith =>
      __$$MbankModelImplCopyWithImpl<_$MbankModelImpl>(this, _$identity);
}

abstract class _MbankModel implements MbankModel {
  const factory _MbankModel(
      {final int? amount,
      final String? quid,
      final DateTime? dateTime}) = _$MbankModelImpl;

  @override
  int? get amount;
  @override
  String? get quid;
  @override
  DateTime? get dateTime;
  @override
  @JsonKey(ignore: true)
  _$$MbankModelImplCopyWith<_$MbankModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
