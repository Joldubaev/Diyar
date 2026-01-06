// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mega_check_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MegaCheckModel _$MegaCheckModelFromJson(Map<String, dynamic> json) {
  return _MegaCheckModel.fromJson(json);
}

/// @nodoc
mixin _$MegaCheckModel {
  int? get commission => throw _privateConstructorUsedError;
  int? get amount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MegaCheckModelCopyWith<MegaCheckModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MegaCheckModelCopyWith<$Res> {
  factory $MegaCheckModelCopyWith(
          MegaCheckModel value, $Res Function(MegaCheckModel) then) =
      _$MegaCheckModelCopyWithImpl<$Res, MegaCheckModel>;
  @useResult
  $Res call({int? commission, int? amount});
}

/// @nodoc
class _$MegaCheckModelCopyWithImpl<$Res, $Val extends MegaCheckModel>
    implements $MegaCheckModelCopyWith<$Res> {
  _$MegaCheckModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commission = freezed,
    Object? amount = freezed,
  }) {
    return _then(_value.copyWith(
      commission: freezed == commission
          ? _value.commission
          : commission // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MegaCheckModelImplCopyWith<$Res>
    implements $MegaCheckModelCopyWith<$Res> {
  factory _$$MegaCheckModelImplCopyWith(_$MegaCheckModelImpl value,
          $Res Function(_$MegaCheckModelImpl) then) =
      __$$MegaCheckModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? commission, int? amount});
}

/// @nodoc
class __$$MegaCheckModelImplCopyWithImpl<$Res>
    extends _$MegaCheckModelCopyWithImpl<$Res, _$MegaCheckModelImpl>
    implements _$$MegaCheckModelImplCopyWith<$Res> {
  __$$MegaCheckModelImplCopyWithImpl(
      _$MegaCheckModelImpl _value, $Res Function(_$MegaCheckModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commission = freezed,
    Object? amount = freezed,
  }) {
    return _then(_$MegaCheckModelImpl(
      commission: freezed == commission
          ? _value.commission
          : commission // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MegaCheckModelImpl implements _MegaCheckModel {
  const _$MegaCheckModelImpl({this.commission, this.amount});

  factory _$MegaCheckModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MegaCheckModelImplFromJson(json);

  @override
  final int? commission;
  @override
  final int? amount;

  @override
  String toString() {
    return 'MegaCheckModel(commission: $commission, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MegaCheckModelImpl &&
            (identical(other.commission, commission) ||
                other.commission == commission) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, commission, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MegaCheckModelImplCopyWith<_$MegaCheckModelImpl> get copyWith =>
      __$$MegaCheckModelImplCopyWithImpl<_$MegaCheckModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MegaCheckModelImplToJson(
      this,
    );
  }
}

abstract class _MegaCheckModel implements MegaCheckModel {
  const factory _MegaCheckModel({final int? commission, final int? amount}) =
      _$MegaCheckModelImpl;

  factory _MegaCheckModel.fromJson(Map<String, dynamic> json) =
      _$MegaCheckModelImpl.fromJson;

  @override
  int? get commission;
  @override
  int? get amount;
  @override
  @JsonKey(ignore: true)
  _$$MegaCheckModelImplCopyWith<_$MegaCheckModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
