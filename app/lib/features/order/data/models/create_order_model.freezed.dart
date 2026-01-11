// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateOrderModel _$CreateOrderModelFromJson(Map<String, dynamic> json) {
  return _CreateOrderModel.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderModel {
  AddressModel get addressData => throw _privateConstructorUsedError;
  ContactInfoModel get contactInfo => throw _privateConstructorUsedError;
  List<FoodItemOrderModel> get foods => throw _privateConstructorUsedError;
  int get dishesCount => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  int get deliveryPrice => throw _privateConstructorUsedError;
  int? get sdacha => throw _privateConstructorUsedError;
  double? get amountToReduce => throw _privateConstructorUsedError;

  /// Serializes this CreateOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrderModelCopyWith<CreateOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderModelCopyWith<$Res> {
  factory $CreateOrderModelCopyWith(
          CreateOrderModel value, $Res Function(CreateOrderModel) then) =
      _$CreateOrderModelCopyWithImpl<$Res, CreateOrderModel>;
  @useResult
  $Res call(
      {AddressModel addressData,
      ContactInfoModel contactInfo,
      List<FoodItemOrderModel> foods,
      int dishesCount,
      String paymentMethod,
      int price,
      int deliveryPrice,
      int? sdacha,
      double? amountToReduce});

  $AddressModelCopyWith<$Res> get addressData;
  $ContactInfoModelCopyWith<$Res> get contactInfo;
}

/// @nodoc
class _$CreateOrderModelCopyWithImpl<$Res, $Val extends CreateOrderModel>
    implements $CreateOrderModelCopyWith<$Res> {
  _$CreateOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressData = null,
    Object? contactInfo = null,
    Object? foods = null,
    Object? dishesCount = null,
    Object? paymentMethod = null,
    Object? price = null,
    Object? deliveryPrice = null,
    Object? sdacha = freezed,
    Object? amountToReduce = freezed,
  }) {
    return _then(_value.copyWith(
      addressData: null == addressData
          ? _value.addressData
          : addressData // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoModel,
      foods: null == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodItemOrderModel>,
      dishesCount: null == dishesCount
          ? _value.dishesCount
          : dishesCount // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      deliveryPrice: null == deliveryPrice
          ? _value.deliveryPrice
          : deliveryPrice // ignore: cast_nullable_to_non_nullable
              as int,
      sdacha: freezed == sdacha
          ? _value.sdacha
          : sdacha // ignore: cast_nullable_to_non_nullable
              as int?,
      amountToReduce: freezed == amountToReduce
          ? _value.amountToReduce
          : amountToReduce // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  /// Create a copy of CreateOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res> get addressData {
    return $AddressModelCopyWith<$Res>(_value.addressData, (value) {
      return _then(_value.copyWith(addressData: value) as $Val);
    });
  }

  /// Create a copy of CreateOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactInfoModelCopyWith<$Res> get contactInfo {
    return $ContactInfoModelCopyWith<$Res>(_value.contactInfo, (value) {
      return _then(_value.copyWith(contactInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateOrderModelImplCopyWith<$Res>
    implements $CreateOrderModelCopyWith<$Res> {
  factory _$$CreateOrderModelImplCopyWith(_$CreateOrderModelImpl value,
          $Res Function(_$CreateOrderModelImpl) then) =
      __$$CreateOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AddressModel addressData,
      ContactInfoModel contactInfo,
      List<FoodItemOrderModel> foods,
      int dishesCount,
      String paymentMethod,
      int price,
      int deliveryPrice,
      int? sdacha,
      double? amountToReduce});

  @override
  $AddressModelCopyWith<$Res> get addressData;
  @override
  $ContactInfoModelCopyWith<$Res> get contactInfo;
}

/// @nodoc
class __$$CreateOrderModelImplCopyWithImpl<$Res>
    extends _$CreateOrderModelCopyWithImpl<$Res, _$CreateOrderModelImpl>
    implements _$$CreateOrderModelImplCopyWith<$Res> {
  __$$CreateOrderModelImplCopyWithImpl(_$CreateOrderModelImpl _value,
      $Res Function(_$CreateOrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressData = null,
    Object? contactInfo = null,
    Object? foods = null,
    Object? dishesCount = null,
    Object? paymentMethod = null,
    Object? price = null,
    Object? deliveryPrice = null,
    Object? sdacha = freezed,
    Object? amountToReduce = freezed,
  }) {
    return _then(_$CreateOrderModelImpl(
      addressData: null == addressData
          ? _value.addressData
          : addressData // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoModel,
      foods: null == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodItemOrderModel>,
      dishesCount: null == dishesCount
          ? _value.dishesCount
          : dishesCount // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      deliveryPrice: null == deliveryPrice
          ? _value.deliveryPrice
          : deliveryPrice // ignore: cast_nullable_to_non_nullable
              as int,
      sdacha: freezed == sdacha
          ? _value.sdacha
          : sdacha // ignore: cast_nullable_to_non_nullable
              as int?,
      amountToReduce: freezed == amountToReduce
          ? _value.amountToReduce
          : amountToReduce // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrderModelImpl extends _CreateOrderModel {
  const _$CreateOrderModelImpl(
      {required this.addressData,
      required this.contactInfo,
      required final List<FoodItemOrderModel> foods,
      required this.dishesCount,
      required this.paymentMethod,
      required this.price,
      required this.deliveryPrice,
      this.sdacha,
      this.amountToReduce})
      : _foods = foods,
        super._();

  factory _$CreateOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderModelImplFromJson(json);

  @override
  final AddressModel addressData;
  @override
  final ContactInfoModel contactInfo;
  final List<FoodItemOrderModel> _foods;
  @override
  List<FoodItemOrderModel> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  @override
  final int dishesCount;
  @override
  final String paymentMethod;
  @override
  final int price;
  @override
  final int deliveryPrice;
  @override
  final int? sdacha;
  @override
  final double? amountToReduce;

  @override
  String toString() {
    return 'CreateOrderModel(addressData: $addressData, contactInfo: $contactInfo, foods: $foods, dishesCount: $dishesCount, paymentMethod: $paymentMethod, price: $price, deliveryPrice: $deliveryPrice, sdacha: $sdacha, amountToReduce: $amountToReduce)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderModelImpl &&
            (identical(other.addressData, addressData) ||
                other.addressData == addressData) &&
            (identical(other.contactInfo, contactInfo) ||
                other.contactInfo == contactInfo) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.dishesCount, dishesCount) ||
                other.dishesCount == dishesCount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.deliveryPrice, deliveryPrice) ||
                other.deliveryPrice == deliveryPrice) &&
            (identical(other.sdacha, sdacha) || other.sdacha == sdacha) &&
            (identical(other.amountToReduce, amountToReduce) ||
                other.amountToReduce == amountToReduce));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      addressData,
      contactInfo,
      const DeepCollectionEquality().hash(_foods),
      dishesCount,
      paymentMethod,
      price,
      deliveryPrice,
      sdacha,
      amountToReduce);

  /// Create a copy of CreateOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderModelImplCopyWith<_$CreateOrderModelImpl> get copyWith =>
      __$$CreateOrderModelImplCopyWithImpl<_$CreateOrderModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderModelImplToJson(
      this,
    );
  }
}

abstract class _CreateOrderModel extends CreateOrderModel {
  const factory _CreateOrderModel(
      {required final AddressModel addressData,
      required final ContactInfoModel contactInfo,
      required final List<FoodItemOrderModel> foods,
      required final int dishesCount,
      required final String paymentMethod,
      required final int price,
      required final int deliveryPrice,
      final int? sdacha,
      final double? amountToReduce}) = _$CreateOrderModelImpl;
  const _CreateOrderModel._() : super._();

  factory _CreateOrderModel.fromJson(Map<String, dynamic> json) =
      _$CreateOrderModelImpl.fromJson;

  @override
  AddressModel get addressData;
  @override
  ContactInfoModel get contactInfo;
  @override
  List<FoodItemOrderModel> get foods;
  @override
  int get dishesCount;
  @override
  String get paymentMethod;
  @override
  int get price;
  @override
  int get deliveryPrice;
  @override
  int? get sdacha;
  @override
  double? get amountToReduce;

  /// Create a copy of CreateOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrderModelImplCopyWith<_$CreateOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
