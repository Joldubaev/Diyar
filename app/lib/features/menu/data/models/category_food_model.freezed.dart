// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_food_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CatergoryFoodModel _$CatergoryFoodModelFromJson(Map<String, dynamic> json) {
  return _CatergoryFoodModel.fromJson(json);
}

/// @nodoc
mixin _$CatergoryFoodModel {
  List<FoodModel>? get foodModels => throw _privateConstructorUsedError;

  /// Serializes this CatergoryFoodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatergoryFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatergoryFoodModelCopyWith<CatergoryFoodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatergoryFoodModelCopyWith<$Res> {
  factory $CatergoryFoodModelCopyWith(
          CatergoryFoodModel value, $Res Function(CatergoryFoodModel) then) =
      _$CatergoryFoodModelCopyWithImpl<$Res, CatergoryFoodModel>;
  @useResult
  $Res call({List<FoodModel>? foodModels});
}

/// @nodoc
class _$CatergoryFoodModelCopyWithImpl<$Res, $Val extends CatergoryFoodModel>
    implements $CatergoryFoodModelCopyWith<$Res> {
  _$CatergoryFoodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatergoryFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodModels = freezed,
  }) {
    return _then(_value.copyWith(
      foodModels: freezed == foodModels
          ? _value.foodModels
          : foodModels // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CatergoryFoodModelImplCopyWith<$Res>
    implements $CatergoryFoodModelCopyWith<$Res> {
  factory _$$CatergoryFoodModelImplCopyWith(_$CatergoryFoodModelImpl value,
          $Res Function(_$CatergoryFoodModelImpl) then) =
      __$$CatergoryFoodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FoodModel>? foodModels});
}

/// @nodoc
class __$$CatergoryFoodModelImplCopyWithImpl<$Res>
    extends _$CatergoryFoodModelCopyWithImpl<$Res, _$CatergoryFoodModelImpl>
    implements _$$CatergoryFoodModelImplCopyWith<$Res> {
  __$$CatergoryFoodModelImplCopyWithImpl(_$CatergoryFoodModelImpl _value,
      $Res Function(_$CatergoryFoodModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CatergoryFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodModels = freezed,
  }) {
    return _then(_$CatergoryFoodModelImpl(
      foodModels: freezed == foodModels
          ? _value._foodModels
          : foodModels // ignore: cast_nullable_to_non_nullable
              as List<FoodModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CatergoryFoodModelImpl implements _CatergoryFoodModel {
  const _$CatergoryFoodModelImpl({final List<FoodModel>? foodModels})
      : _foodModels = foodModels;

  factory _$CatergoryFoodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatergoryFoodModelImplFromJson(json);

  final List<FoodModel>? _foodModels;
  @override
  List<FoodModel>? get foodModels {
    final value = _foodModels;
    if (value == null) return null;
    if (_foodModels is EqualUnmodifiableListView) return _foodModels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CatergoryFoodModel(foodModels: $foodModels)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatergoryFoodModelImpl &&
            const DeepCollectionEquality()
                .equals(other._foodModels, _foodModels));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_foodModels));

  /// Create a copy of CatergoryFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatergoryFoodModelImplCopyWith<_$CatergoryFoodModelImpl> get copyWith =>
      __$$CatergoryFoodModelImplCopyWithImpl<_$CatergoryFoodModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatergoryFoodModelImplToJson(
      this,
    );
  }
}

abstract class _CatergoryFoodModel implements CatergoryFoodModel {
  const factory _CatergoryFoodModel({final List<FoodModel>? foodModels}) =
      _$CatergoryFoodModelImpl;

  factory _CatergoryFoodModel.fromJson(Map<String, dynamic> json) =
      _$CatergoryFoodModelImpl.fromJson;

  @override
  List<FoodModel>? get foodModels;

  /// Create a copy of CatergoryFoodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatergoryFoodModelImplCopyWith<_$CatergoryFoodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
