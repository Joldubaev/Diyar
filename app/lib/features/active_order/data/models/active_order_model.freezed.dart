// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActiveOrderModel _$ActiveOrderModelFromJson(Map<String, dynamic> json) {
  return _ActiveOrderModel.fromJson(json);
}

/// @nodoc
mixin _$ActiveOrderModel {
  OrderActiveItemModel? get order => throw _privateConstructorUsedError;
  String? get courierName => throw _privateConstructorUsedError;
  String? get courierNumber => throw _privateConstructorUsedError;

  /// Serializes this ActiveOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveOrderModelCopyWith<ActiveOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveOrderModelCopyWith<$Res> {
  factory $ActiveOrderModelCopyWith(
          ActiveOrderModel value, $Res Function(ActiveOrderModel) then) =
      _$ActiveOrderModelCopyWithImpl<$Res, ActiveOrderModel>;
  @useResult
  $Res call(
      {OrderActiveItemModel? order,
      String? courierName,
      String? courierNumber});

  $OrderActiveItemModelCopyWith<$Res>? get order;
}

/// @nodoc
class _$ActiveOrderModelCopyWithImpl<$Res, $Val extends ActiveOrderModel>
    implements $ActiveOrderModelCopyWith<$Res> {
  _$ActiveOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = freezed,
    Object? courierName = freezed,
    Object? courierNumber = freezed,
  }) {
    return _then(_value.copyWith(
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderActiveItemModel?,
      courierName: freezed == courierName
          ? _value.courierName
          : courierName // ignore: cast_nullable_to_non_nullable
              as String?,
      courierNumber: freezed == courierNumber
          ? _value.courierNumber
          : courierNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ActiveOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderActiveItemModelCopyWith<$Res>? get order {
    if (_value.order == null) {
      return null;
    }

    return $OrderActiveItemModelCopyWith<$Res>(_value.order!, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActiveOrderModelImplCopyWith<$Res>
    implements $ActiveOrderModelCopyWith<$Res> {
  factory _$$ActiveOrderModelImplCopyWith(_$ActiveOrderModelImpl value,
          $Res Function(_$ActiveOrderModelImpl) then) =
      __$$ActiveOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OrderActiveItemModel? order,
      String? courierName,
      String? courierNumber});

  @override
  $OrderActiveItemModelCopyWith<$Res>? get order;
}

/// @nodoc
class __$$ActiveOrderModelImplCopyWithImpl<$Res>
    extends _$ActiveOrderModelCopyWithImpl<$Res, _$ActiveOrderModelImpl>
    implements _$$ActiveOrderModelImplCopyWith<$Res> {
  __$$ActiveOrderModelImplCopyWithImpl(_$ActiveOrderModelImpl _value,
      $Res Function(_$ActiveOrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = freezed,
    Object? courierName = freezed,
    Object? courierNumber = freezed,
  }) {
    return _then(_$ActiveOrderModelImpl(
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderActiveItemModel?,
      courierName: freezed == courierName
          ? _value.courierName
          : courierName // ignore: cast_nullable_to_non_nullable
              as String?,
      courierNumber: freezed == courierNumber
          ? _value.courierNumber
          : courierNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActiveOrderModelImpl implements _ActiveOrderModel {
  const _$ActiveOrderModelImpl(
      {this.order, this.courierName, this.courierNumber});

  factory _$ActiveOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveOrderModelImplFromJson(json);

  @override
  final OrderActiveItemModel? order;
  @override
  final String? courierName;
  @override
  final String? courierNumber;

  @override
  String toString() {
    return 'ActiveOrderModel(order: $order, courierName: $courierName, courierNumber: $courierNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveOrderModelImpl &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.courierName, courierName) ||
                other.courierName == courierName) &&
            (identical(other.courierNumber, courierNumber) ||
                other.courierNumber == courierNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, order, courierName, courierNumber);

  /// Create a copy of ActiveOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveOrderModelImplCopyWith<_$ActiveOrderModelImpl> get copyWith =>
      __$$ActiveOrderModelImplCopyWithImpl<_$ActiveOrderModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveOrderModelImplToJson(
      this,
    );
  }
}

abstract class _ActiveOrderModel implements ActiveOrderModel {
  const factory _ActiveOrderModel(
      {final OrderActiveItemModel? order,
      final String? courierName,
      final String? courierNumber}) = _$ActiveOrderModelImpl;

  factory _ActiveOrderModel.fromJson(Map<String, dynamic> json) =
      _$ActiveOrderModelImpl.fromJson;

  @override
  OrderActiveItemModel? get order;
  @override
  String? get courierName;
  @override
  String? get courierNumber;

  /// Create a copy of ActiveOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveOrderModelImplCopyWith<_$ActiveOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
