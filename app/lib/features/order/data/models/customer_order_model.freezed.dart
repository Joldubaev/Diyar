// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomerOrderModel _$CustomerOrderModelFromJson(Map<String, dynamic> json) {
  return _CustomerOrderModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerOrderModel {
  String? get id => throw _privateConstructorUsedError;
  List<FoodModel>? get foods => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this CustomerOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerOrderModelCopyWith<CustomerOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerOrderModelCopyWith<$Res> {
  factory $CustomerOrderModelCopyWith(
          CustomerOrderModel value, $Res Function(CustomerOrderModel) then) =
      _$CustomerOrderModelCopyWithImpl<$Res, CustomerOrderModel>;
  @useResult
  $Res call(
      {String? id, List<FoodModel>? foods, String? address, String? status});
}

/// @nodoc
class _$CustomerOrderModelCopyWithImpl<$Res, $Val extends CustomerOrderModel>
    implements $CustomerOrderModelCopyWith<$Res> {
  _$CustomerOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? foods = freezed,
    Object? address = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      foods: freezed == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerOrderModelImplCopyWith<$Res>
    implements $CustomerOrderModelCopyWith<$Res> {
  factory _$$CustomerOrderModelImplCopyWith(_$CustomerOrderModelImpl value,
          $Res Function(_$CustomerOrderModelImpl) then) =
      __$$CustomerOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id, List<FoodModel>? foods, String? address, String? status});
}

/// @nodoc
class __$$CustomerOrderModelImplCopyWithImpl<$Res>
    extends _$CustomerOrderModelCopyWithImpl<$Res, _$CustomerOrderModelImpl>
    implements _$$CustomerOrderModelImplCopyWith<$Res> {
  __$$CustomerOrderModelImplCopyWithImpl(_$CustomerOrderModelImpl _value,
      $Res Function(_$CustomerOrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomerOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? foods = freezed,
    Object? address = freezed,
    Object? status = freezed,
  }) {
    return _then(_$CustomerOrderModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      foods: freezed == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerOrderModelImpl implements _CustomerOrderModel {
  const _$CustomerOrderModelImpl(
      {this.id, final List<FoodModel>? foods, this.address, this.status})
      : _foods = foods;

  factory _$CustomerOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerOrderModelImplFromJson(json);

  @override
  final String? id;
  final List<FoodModel>? _foods;
  @override
  List<FoodModel>? get foods {
    final value = _foods;
    if (value == null) return null;
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? address;
  @override
  final String? status;

  @override
  String toString() {
    return 'CustomerOrderModel(id: $id, foods: $foods, address: $address, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(_foods), address, status);

  /// Create a copy of CustomerOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerOrderModelImplCopyWith<_$CustomerOrderModelImpl> get copyWith =>
      __$$CustomerOrderModelImplCopyWithImpl<_$CustomerOrderModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerOrderModelImplToJson(
      this,
    );
  }
}

abstract class _CustomerOrderModel implements CustomerOrderModel {
  const factory _CustomerOrderModel(
      {final String? id,
      final List<FoodModel>? foods,
      final String? address,
      final String? status}) = _$CustomerOrderModelImpl;

  factory _CustomerOrderModel.fromJson(Map<String, dynamic> json) =
      _$CustomerOrderModelImpl.fromJson;

  @override
  String? get id;
  @override
  List<FoodModel>? get foods;
  @override
  String? get address;
  @override
  String? get status;

  /// Create a copy of CustomerOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerOrderModelImplCopyWith<_$CustomerOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
