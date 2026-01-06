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

/// @nodoc
mixin _$CreateOrderModel {
  AddressModel? get addressData => throw _privateConstructorUsedError;
  ContactInfoModel? get contactInfo => throw _privateConstructorUsedError;
  int? get dishesCount => throw _privateConstructorUsedError;
  List<FoodItemOrderModel>? get foods => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  int? get deliveryPrice => throw _privateConstructorUsedError;
  int? get sdacha => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      {AddressModel? addressData,
      ContactInfoModel? contactInfo,
      int? dishesCount,
      List<FoodItemOrderModel>? foods,
      String? paymentMethod,
      int? price,
      int? deliveryPrice,
      int? sdacha});

  $AddressModelCopyWith<$Res>? get addressData;
  $ContactInfoModelCopyWith<$Res>? get contactInfo;
}

/// @nodoc
class _$CreateOrderModelCopyWithImpl<$Res, $Val extends CreateOrderModel>
    implements $CreateOrderModelCopyWith<$Res> {
  _$CreateOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressData = freezed,
    Object? contactInfo = freezed,
    Object? dishesCount = freezed,
    Object? foods = freezed,
    Object? paymentMethod = freezed,
    Object? price = freezed,
    Object? deliveryPrice = freezed,
    Object? sdacha = freezed,
  }) {
    return _then(_value.copyWith(
      addressData: freezed == addressData
          ? _value.addressData
          : addressData // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      contactInfo: freezed == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoModel?,
      dishesCount: freezed == dishesCount
          ? _value.dishesCount
          : dishesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      foods: freezed == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodItemOrderModel>?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      deliveryPrice: freezed == deliveryPrice
          ? _value.deliveryPrice
          : deliveryPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      sdacha: freezed == sdacha
          ? _value.sdacha
          : sdacha // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get addressData {
    if (_value.addressData == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.addressData!, (value) {
      return _then(_value.copyWith(addressData: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ContactInfoModelCopyWith<$Res>? get contactInfo {
    if (_value.contactInfo == null) {
      return null;
    }

    return $ContactInfoModelCopyWith<$Res>(_value.contactInfo!, (value) {
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
      {AddressModel? addressData,
      ContactInfoModel? contactInfo,
      int? dishesCount,
      List<FoodItemOrderModel>? foods,
      String? paymentMethod,
      int? price,
      int? deliveryPrice,
      int? sdacha});

  @override
  $AddressModelCopyWith<$Res>? get addressData;
  @override
  $ContactInfoModelCopyWith<$Res>? get contactInfo;
}

/// @nodoc
class __$$CreateOrderModelImplCopyWithImpl<$Res>
    extends _$CreateOrderModelCopyWithImpl<$Res, _$CreateOrderModelImpl>
    implements _$$CreateOrderModelImplCopyWith<$Res> {
  __$$CreateOrderModelImplCopyWithImpl(_$CreateOrderModelImpl _value,
      $Res Function(_$CreateOrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressData = freezed,
    Object? contactInfo = freezed,
    Object? dishesCount = freezed,
    Object? foods = freezed,
    Object? paymentMethod = freezed,
    Object? price = freezed,
    Object? deliveryPrice = freezed,
    Object? sdacha = freezed,
  }) {
    return _then(_$CreateOrderModelImpl(
      addressData: freezed == addressData
          ? _value.addressData
          : addressData // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      contactInfo: freezed == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoModel?,
      dishesCount: freezed == dishesCount
          ? _value.dishesCount
          : dishesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      foods: freezed == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodItemOrderModel>?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      deliveryPrice: freezed == deliveryPrice
          ? _value.deliveryPrice
          : deliveryPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      sdacha: freezed == sdacha
          ? _value.sdacha
          : sdacha // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$CreateOrderModelImpl implements _CreateOrderModel {
  const _$CreateOrderModelImpl(
      {this.addressData,
      this.contactInfo,
      this.dishesCount,
      final List<FoodItemOrderModel>? foods,
      this.paymentMethod,
      this.price,
      this.deliveryPrice,
      this.sdacha})
      : _foods = foods;

  @override
  final AddressModel? addressData;
  @override
  final ContactInfoModel? contactInfo;
  @override
  final int? dishesCount;
  final List<FoodItemOrderModel>? _foods;
  @override
  List<FoodItemOrderModel>? get foods {
    final value = _foods;
    if (value == null) return null;
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? paymentMethod;
  @override
  final int? price;
  @override
  final int? deliveryPrice;
  @override
  final int? sdacha;

  @override
  String toString() {
    return 'CreateOrderModel(addressData: $addressData, contactInfo: $contactInfo, dishesCount: $dishesCount, foods: $foods, paymentMethod: $paymentMethod, price: $price, deliveryPrice: $deliveryPrice, sdacha: $sdacha)';
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
            (identical(other.dishesCount, dishesCount) ||
                other.dishesCount == dishesCount) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.deliveryPrice, deliveryPrice) ||
                other.deliveryPrice == deliveryPrice) &&
            (identical(other.sdacha, sdacha) || other.sdacha == sdacha));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      addressData,
      contactInfo,
      dishesCount,
      const DeepCollectionEquality().hash(_foods),
      paymentMethod,
      price,
      deliveryPrice,
      sdacha);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderModelImplCopyWith<_$CreateOrderModelImpl> get copyWith =>
      __$$CreateOrderModelImplCopyWithImpl<_$CreateOrderModelImpl>(
          this, _$identity);
}

abstract class _CreateOrderModel implements CreateOrderModel {
  const factory _CreateOrderModel(
      {final AddressModel? addressData,
      final ContactInfoModel? contactInfo,
      final int? dishesCount,
      final List<FoodItemOrderModel>? foods,
      final String? paymentMethod,
      final int? price,
      final int? deliveryPrice,
      final int? sdacha}) = _$CreateOrderModelImpl;

  @override
  AddressModel? get addressData;
  @override
  ContactInfoModel? get contactInfo;
  @override
  int? get dishesCount;
  @override
  List<FoodItemOrderModel>? get foods;
  @override
  String? get paymentMethod;
  @override
  int? get price;
  @override
  int? get deliveryPrice;
  @override
  int? get sdacha;
  @override
  @JsonKey(ignore: true)
  _$$CreateOrderModelImplCopyWith<_$CreateOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
