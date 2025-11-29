// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curier_food_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CurierFoodModel _$CurierFoodModelFromJson(Map<String, dynamic> json) {
  return _CurierFoodModel.fromJson(json);
}

/// @nodoc
mixin _$CurierFoodModel {
  int? get quantity => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;

  /// Serializes this CurierFoodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurierFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurierFoodModelCopyWith<CurierFoodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurierFoodModelCopyWith<$Res> {
  factory $CurierFoodModelCopyWith(
          CurierFoodModel value, $Res Function(CurierFoodModel) then) =
      _$CurierFoodModelCopyWithImpl<$Res, CurierFoodModel>;
  @useResult
  $Res call({int? quantity, String? name, int? price});
}

/// @nodoc
class _$CurierFoodModelCopyWithImpl<$Res, $Val extends CurierFoodModel>
    implements $CurierFoodModelCopyWith<$Res> {
  _$CurierFoodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurierFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = freezed,
    Object? name = freezed,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurierFoodModelImplCopyWith<$Res>
    implements $CurierFoodModelCopyWith<$Res> {
  factory _$$CurierFoodModelImplCopyWith(_$CurierFoodModelImpl value,
          $Res Function(_$CurierFoodModelImpl) then) =
      __$$CurierFoodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? quantity, String? name, int? price});
}

/// @nodoc
class __$$CurierFoodModelImplCopyWithImpl<$Res>
    extends _$CurierFoodModelCopyWithImpl<$Res, _$CurierFoodModelImpl>
    implements _$$CurierFoodModelImplCopyWith<$Res> {
  __$$CurierFoodModelImplCopyWithImpl(
      _$CurierFoodModelImpl _value, $Res Function(_$CurierFoodModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurierFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = freezed,
    Object? name = freezed,
    Object? price = freezed,
  }) {
    return _then(_$CurierFoodModelImpl(
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurierFoodModelImpl implements _CurierFoodModel {
  const _$CurierFoodModelImpl({this.quantity, this.name, this.price});

  factory _$CurierFoodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurierFoodModelImplFromJson(json);

  @override
  final int? quantity;
  @override
  final String? name;
  @override
  final int? price;

  @override
  String toString() {
    return 'CurierFoodModel(quantity: $quantity, name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurierFoodModelImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, name, price);

  /// Create a copy of CurierFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurierFoodModelImplCopyWith<_$CurierFoodModelImpl> get copyWith =>
      __$$CurierFoodModelImplCopyWithImpl<_$CurierFoodModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurierFoodModelImplToJson(
      this,
    );
  }
}

abstract class _CurierFoodModel implements CurierFoodModel {
  const factory _CurierFoodModel(
      {final int? quantity,
      final String? name,
      final int? price}) = _$CurierFoodModelImpl;

  factory _CurierFoodModel.fromJson(Map<String, dynamic> json) =
      _$CurierFoodModelImpl.fromJson;

  @override
  int? get quantity;
  @override
  String? get name;
  @override
  int? get price;

  /// Create a copy of CurierFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurierFoodModelImplCopyWith<_$CurierFoodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
